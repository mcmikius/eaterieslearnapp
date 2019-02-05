//
//  EateryDetailViewController.swift
//  Eateries
//
//  Created by Michail Bondarenko on 2/1/19.
//  Copyright © 2019 Michail Bondarenko. All rights reserved.
//

import UIKit

class EateryDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rateButton: UIButton!
    
    var restaurant: Restaurant?
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard let sourceViewController = segue.source as? RateViewController else { return }
        guard let rating = sourceViewController.restRating else { return }
        rateButton.setImage(UIImage(named: rating), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttons = [rateButton, mapButton]
        for button in buttons {
            guard let button = button else { break }
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
        }
        tableView.estimatedRowHeight = 38
        tableView.rowHeight = UITableView.automaticDimension
        
        imageView.image = UIImage(data: restaurant!.image! as Data)
        
        
//        tableView.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
//        tableView.separatorColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        title = restaurant!.name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateryDetailTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.keyLabel.text = "Name"
            cell.valueLabel.text = restaurant!.name
        case 1:
            cell.keyLabel.text = "Type"
            cell.valueLabel.text = restaurant!.type
        case 2:
            cell.keyLabel.text = "Address"
            cell.valueLabel.text = restaurant!.location
        case 3:
            cell.keyLabel.text = "Did I was here?"
            cell.valueLabel.text = restaurant!.isVisited ? "Yes" : "No"
        default:
            break
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue" {
            let destinationViewController = segue.destination as! MapViewController
            destinationViewController.restaurant = self.restaurant
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
