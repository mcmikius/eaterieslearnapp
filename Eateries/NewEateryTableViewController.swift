//
//  NewEateryTableViewController.swift
//  Eateries
//
//  Created by Michail Bondarenko on 2/2/19.
//  Copyright © 2019 Michail Bondarenko. All rights reserved.
//

import UIKit
import CloudKit

class NewEateryTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    var isVisited = false
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if nameTextField.text == "" || addressTextField.text == "" || typeTextField.text == "" {
            let alertController = UIAlertController(title: NSLocalizedString("Error!", comment: "Error!"), message: NSLocalizedString("Not all fields have been filled.", comment: "Not all fields have been filled."), preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController,animated: true, completion: nil)
        } else {

            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                let restaurant = Restaurant(context: context)
                restaurant.name = nameTextField.text
                restaurant.location = addressTextField.text
                restaurant.type = typeTextField.text
                restaurant.isVisited = isVisited
                if let image = imageView.image {
                    restaurant.image = image.pngData()
                }
                do {
                    try context.save()
                    print("Save is true!")
                } catch let error as NSError {
                    print("Data was not save \(error), \(error.userInfo)")
                }
                saveToiColoud(restaurant)
            }
            performSegue(withIdentifier: "unwindSegueFromNewEatery", sender: self)
        }
    }
    @IBAction func toggleIsVisitedPressed(_ sender: UIButton) {
        if sender == yesButton {
            sender.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            noButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            isVisited = true
        } else {
            sender.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            yesButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            isVisited = false
        }
    }
    
    func saveToiColoud(_ restaurant: Restaurant) {
        let restRecord = CKRecord(recordType: "Restaurant")
        restRecord.setValue(nameTextField.text, forKey: "name")
        restRecord.setValue(typeTextField.text, forKey: "type")
        restRecord.setValue(addressTextField.text, forKey: "location")
        
        guard let originImage = UIImage(data: restaurant.image! as Data) else { return }
        let scale = originImage.size.width > 1080.0 ? 1080.0 / originImage.size.width : 1.0
        let scaledImage = UIImage(data: restaurant.image as! Data, scale: scale)
        let imageFilePath = NSTemporaryDirectory() + restaurant.name!
        let imageFileURL = URL(fileURLWithPath: imageFilePath)
        
        do {
            try scaledImage?.jpegData(compressionQuality: 0.7)?.write(to: imageFileURL, options: .atomic)
//            try UIImageJPEGRepresentation(scaledImage!, 0.7)?.write(to: imageFileURL, options: .atomic)
        } catch {
            print(error.localizedDescription)
        }
        
        let imageAsset = CKAsset(fileURL: imageFileURL)
        restRecord.setValue(imageAsset, forKey: "image")
        let publicDataBase = CKContainer.default().publicCloudDatabase
        publicDataBase.save(restRecord) { (record, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            do {
                try FileManager.default.removeItem(at: imageFileURL)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        yesButton.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        noButton.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let alertController = UIAlertController(title: NSLocalizedString("Photo source", comment: "Photo source"), message: nil, preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment: "Camera"), style: .default, handler: { (action) in
                self.chooseImagePickerAction(source: .camera)
            })
            let photoAction = UIAlertAction(title: NSLocalizedString("Photo", comment: "Photo"), style: .default, handler: { (action) in
                self.chooseImagePickerAction(source: .photoLibrary)
            })
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
            alertController.addAction(cameraAction)
            alertController.addAction(photoAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func chooseImagePickerAction(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
