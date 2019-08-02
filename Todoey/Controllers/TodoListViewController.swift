//
//  ViewController.swift
//  Todoey
//
//  Created by Anit Patel on 01/08/2019.
//  Copyright © 2019 TerikLimited. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)

        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
        // read the contents of the userdefaults plist file for key ToDoListArray back into the array.
        // check that the user default file exists ...
        //
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        }
        
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
        
        // force the view to reload the data by passing the dataSource delegate method again.
        //
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert )
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
        
            // what will happen once the user clicks the add item on our UIAlert.
            //
            // create Item object, assign its title property,
            // add object to the array.
            //
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            // save itemArray to defaults local storage
            //
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            // force the view to reload from the array.
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
    

}

