//
//  ViewController.swift
//  Todoey
//
//  Created by Anit Patel on 01/08/2019.
//  Copyright © 2019 TerikLimited. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    // initialise a new Realm. Forcing the try is OK in this instance
    //
    let realm = try! Realm()

    var todoItems : Results<Item>?
    
    var selectedCategory : Category? {
        didSet {
            // call the parameter without parameter...it will be defaulted if not supplied
            // when called.
            //
           loadItems()
        }
    }

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

//        not required as I set the view controller delegate in the storyboard.
//
//        searchBar.delegate = self
        
    }

    //Mark - Tableview Datasource Methods
    //TODO: Declare cellForRowAtIndexPath here:
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            // set the cells accessory based on the done property of the current
            // row.
            //
            // ternary operator:
            // value = condition ? valueIfTrue : valueIfFalse
            // cell.accessoryType = item.done == true ? .checkmark : .none
            //
            cell.accessoryType = item.done  ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        

        return cell
        
    }
    
    //TODO: Declare numberOfRowsInSection here:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
        
    }
    
    //Mark - tableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print ("Error saving done status \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert )
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
        
            // check that the selectedCategory is not nil then
            // try and write the item to the realm, and associate it
            // with the parent category
            //
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        
                        // add the item to the items collection of the category
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving Item realm \(error)")
                }
            }
            
            // force the table view to reload.
            //
            self.tableView.reloadData()
            
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
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()

    }
}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {

    // delegate mathods for UISearchBar
    //
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // filter todoItems by the predicate text in the search bar text, and sort the result by the title ascending
        // assign the result set back to todoItems
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
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
