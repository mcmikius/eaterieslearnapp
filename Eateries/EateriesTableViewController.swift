//
//  EateriesTableViewController.swift
//  Eateries
//
//  Created by Michail Bondarenko on 1/31/19.
//  Copyright © 2019 Michail Bondarenko. All rights reserved.
//

import UIKit
import CoreData

class EateriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultsController: NSFetchedResultsController<Restaurant>!
    var searchController: UISearchController!
    var filteredResultArray: [Restaurant] = []
    var restaurants: [Restaurant] = []
//        Restaurant(name: "Ogonёk Grill&Bar", type: "restaurant", location: "Kyiv, bld. Shevchenko 37", image: "ogonek.jpg", isVisited: false),
//        Restaurant(name: "Елу", type: "restaurant", location: "Kyiv", image: "elu.jpg", isVisited: false),
//        Restaurant(name: "Bonsai", type: "restaurant", location: "Kyiv", image: "bonsai.jpg", isVisited: false),
//        Restaurant(name: "Дастархан", type: "restaurant", location: "Kyiv", image: "dastarhan.jpg", isVisited: false),
//        Restaurant(name: "Индокитай", type: "restaurant", location: "Kyiv", image: "indokitay.jpg", isVisited: false),
//        Restaurant(name: "X.O", type: "club", location: "Kyiv", image: "x.o.jpg", isVisited: false),
//        Restaurant(name: "Балкан Гриль", type: "restaurant", location: "Kyiv", image: "balkan.jpg", isVisited: false),
//        Restaurant(name: "Respublica", type: "restaurant", location: "Kyiv", image: "respublika.jpg", isVisited: false),
//        Restaurant(name: "Speak Easy", type: "restaurant complex", location: "Kyiv", image: "speakeasy.jpg", isVisited: false),
//        Restaurant(name: "Morris Pub", type: "restaurant", location: "Kyiv", image: "morris.jpg", isVisited: false),
//        Restaurant(name: "Вкусные истории", type: "restaurant", location: "Kyiv", image: "istorii.jpg", isVisited: false),
//        Restaurant(name: "Классик", type: "restaurant", location: "Kyiv", image: "klassik.jpg", isVisited: false),
//        Restaurant(name: "Love&Life", type: "restaurant", location: "Kyiv", image: "love.jpg", isVisited: false),
//        Restaurant(name: "Шок", type: "restaurant", location: "Kyiv", image: "shok.jpg", isVisited: false),
//        Restaurant(name: "Бочка", type: "restaurant", location:  "Kyiv", image: "bochka.jpg", isVisited: false)]
    
    @IBAction func close(segue: UIStoryboardSegue) {
        
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
    }
    
    func filterContentFor(searchText text: String) {
        filteredResultArray = restaurants.filter { (restaurant) -> Bool in
            return (restaurant.name?.lowercased().contains(text.lowercased()))!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        searchController.searchBar.tintColor = .white
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableView.automaticDimension
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            
            do {
                try fetchResultsController.performFetch()
                restaurants = fetchResultsController.fetchedObjects!
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let userDefaults = UserDefaults.standard
        let wasIntroWatched = userDefaults.bool(forKey: "wasIntroWatched")
        
        guard !wasIntroWatched else { return }
        
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "pageViewController") as? PageViewController {
            present(pageViewController, animated: true, completion: nil)
        }
    }
    // MARK: - Fetch results controller delegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert: guard let indexPath = newIndexPath else { break }
        tableView.insertRows(at: [indexPath], with: .fade)
        case .delete: guard let indexPath = indexPath else { break }
        tableView.deleteRows(at: [indexPath], with: .fade)
        case .update: guard let indexPath = indexPath else { break }
        tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        restaurants = controller.fetchedObjects as! [Restaurant]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredResultArray.count
        }
        return restaurants.count
    }
    
    func restaurantToDisplayAt(indexPath: IndexPath) -> Restaurant {
        let restaurant: Restaurant
        if searchController.isActive && searchController.searchBar.text != "" {
            restaurant = filteredResultArray[indexPath.row]
        } else {
            restaurant = restaurants[indexPath.row]
        }
        return restaurant
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateriesTableViewCell
        let restaurant = restaurantToDisplayAt(indexPath: indexPath)
        cell.thumbnailImageView.image = UIImage(data: restaurant.image! as Data)
        cell.thumbnailImageView.layer.cornerRadius = 32.5
        cell.thumbnailImageView.clipsToBounds = true
        cell.nameLabel.text = restaurant.name
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        
        cell.accessoryType = restaurant.isVisited ? .checkmark : .none
        
        return cell
    }
 
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let actionSheetController = UIAlertController(title: nil, message: "Choise an action", preferredStyle: .actionSheet)
//        let callAction = UIAlertAction(title: "Call to: +38(067)478-33-3\(indexPath.row)", style: .default) { (action: UIAlertAction) -> Void in
//            let alertController = UIAlertController(title: nil, message: "Call cannot be made", preferredStyle: .alert)
//            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alertController.addAction(ok)
//            self.present(alertController, animated: true, completion: nil)
//        }
//            
//        let isVisitedTitle = self.restorantIsVisited[indexPath.row] ? "I was't be here" : "I was here"
//        let isVisited = UIAlertAction(title: isVisitedTitle, style: .default) { (action) in
//            let cell = tableView.cellForRow(at: indexPath)
//                
//            self.restorantIsVisited[indexPath.row] = !self.restorantIsVisited[indexPath.row]
//            cell?.accessoryType = self.restorantIsVisited[indexPath.row] ? .checkmark : .none
//        }
//            
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        actionSheetController.addAction(callAction)
//        actionSheetController.addAction(isVisited)
//        actionSheetController.addAction(cancel)
//            
//        present(actionSheetController, animated: true, completion: nil)
//            
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            self.restaurantImages.remove(at: indexPath.row)
//            self.restaurantNames.remove(at: indexPath.row)
//            self.restorantIsVisited.remove(at: indexPath.row)
//        }
//        tableView.deleteRows(at: [indexPath], with: .fade)
//    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let share = UITableViewRowAction(style: .default, title: "share") { (action, indexPath) in
            let defaultText = "I'm in " + self.restaurants[indexPath.row].name!
            if let image = UIImage(data: self.restaurants[indexPath.row].image! as Data) {
                let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        
        let delete = UITableViewRowAction(style: .default, title: "delete") { (action, indexPath) in
            self.restaurants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                let objectToDelete = self.fetchResultsController.object(at: indexPath)
                context.delete(objectToDelete)
                do {
                    try context.save()
                } catch {
                 print(error.localizedDescription)
                }
            }
        }
        share.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        delete.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        return [delete, share]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationViewController = segue.destination as! EateryDetailViewController
                destinationViewController.restaurant = restaurantToDisplayAt(indexPath: indexPath)
            }
        }
    }
}

extension EateriesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
}

extension EateriesTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            navigationController?.hidesBarsOnSwipe = false
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true
    }
}
