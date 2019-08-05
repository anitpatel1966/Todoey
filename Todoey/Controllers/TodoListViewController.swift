//
//  ViewController.swift
//  Todoey
//
//  Created by Anit Patel on 01/08/2019.
//  Copyright © 2019 TerikLimited. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet {
            // call the parameter without parameter...it will be defaulted if not supplied
            // when called.
            //
            loadItems()
        }
    }

    @IBOutlet weak var searchBar: UISearchBar!
    
    //
    // get the viewContext using the singleton UIApplication.shared that represents the AppDelegate object.
    //
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        searchBar.delegate = self
        
    }

    //Mark - Tableview Datasource Methods
    //TODO: Declare cellForRowAtIndexPath here:
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // set the cells accessory based on the done property of the current
        // row.
        //
        // ternary operator:
        // value = condition ? valueIfTrue : valueIfFalse
        // cell.accessoryType = item.done == true ? .checkmark : .none
        //
        cell.accessoryType = item.done  ? .checkmark : .none

        return cell
        
    }
    
    //TODO: Declare numberOfRowsInSection here:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    //Mark - tableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // print (itemArray[indexPath.row])
        
        // toggle the boolean from true <-> false
        //
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // delete a row / NSManaged object from context and array/model
        // MUST remove from the context first and then from the model
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: itemArray[indexPath.row])
        
        // save the model to the contexte which will also...
        // force the view to reload the data by calling the dataSource delegate method again.
        //
        self.saveItems()

        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert )
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
        
            // Create the item within the context, and later add it to the array. Then save the context using function.
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            // what is the parent of the item? it is the selected category from the previous view.
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        // add a text field to the alert.
        //
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            
            // assign to a variable available in the wider scope of this function.
            //
            textField = alertTextField
        }
        
        // adds the defined action to the alert.
        //
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model manipulation methods
    
    func saveItems() {

        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        // force the view to reload from the array.
        tableView.reloadData()
    }

    // load the data from the context back into the data model.
    // If request paramter is not supplied by caller, then default it.
    // If the predicate paramter is not supplied by the caller, then default it to nil.
    //
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//        request.predicate = compoundPredicate
        
        // check whether a predicate was passed as a parameter?
        // will default to nil if not passed by caller.
        //
        // if predicate is passed (i.e. search predicate) then use a compoundPredicate to
        // to get all Items that have this parent category and match the search param
        // else
        // just retrieve items based on the parent category predicate.
        //
        if let additionalPredicate  = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        // fetch back data of type Item using the
        // request passed in
        do {
            itemArray = try context.fetch(request)
        } catch {
            print ("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()

    }
}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {

    // delegate mathods for UISearchBar
    //
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()

        // add the search criteria to the request.
        //
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // add sort clause to the request.
        //
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
//
//      below is the shorted code.
//
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        // from the context, execute the request. The request contains the
        // search criteria (predicate) and sort criteria.
        //
        loadItems(with: request, predicate: predicate)
        
    }
    
    // delegate called when search bar text changed by user.
    // if the search bar is empty, then call loadItems to get all the
    // data again from the context.
    //
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            
            // On the main execution queue...
            //
            // tell the application that the search bar should no longer be the
            // current UI object. go back to original state before user clicked in
            // search bar.
            // No cursor or keybaord
            //
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
    

}
