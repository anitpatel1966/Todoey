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

    // get the filepath for the user document directory.
    // create a path to our own plist file Items.plist
    //
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        loadItems()
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
        
        // save the model to the plist file which will also...
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
        
            // what will happen once the user clicks the add item on our UIAlert.
            //
            // create Item object, assign its title property,
            // add object to the array.
            //
            let newItem = Item()
            newItem.title = textField.text!
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
        //
        // save itemArray to plist:
        //
        // 1) create an encoder object
        // 2) encode our item array using the encoder
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print ("Error encoding itemArray \(error)")
        }
        
        // force the view to reload from the array.
        tableView.reloadData()
    }

    // load the data from the plist file back into the data model.
    func loadItems() {

        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print ("Error decoding into itemArray \(error)")
            }
        }
    }
}

