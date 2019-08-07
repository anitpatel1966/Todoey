//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Anit Patel on 05/08/2019.
//  Copyright © 2019 TerikLimited. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    // initialise a new Realm. Forcing the try is OK in this instance
    //
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // call the parameter without parameter...it will be defaulted if not supplied
        // when called.
        //
        loadCategories()
        
        // removes the lines between the rows in the view.
        //
        tableView.separatorStyle = .none
                
    }
    

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // if categories is not nil, return the count, otherwise return 1.
        // Nil Coalescing operator.
        //
        return categories?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // call the tableView method in the superclass SwipeTableViewController for the current index
        // and return the cell.
        //
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        let colour = categories?[indexPath.row].colour ?? UIColor.randomFlat.hexValue()
        
        cell.backgroundColor = UIColor(hexString:  colour)
        
        return cell
        
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    

    //MARK: - Add new categories
    //
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert )
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            // Create a Category object from the Class, then set its name property.
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
            
        }
        
        // adds the defined action to the alert.
        //
        alert.addAction(action)
        
        // add a text field to the alert.
        //
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            
            // assign to a variable available in the wider scope of this function.
            //
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    

    
    
    //MARK - Model manipulation methods
    
    func save(category : Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        
        // force the view to reload from the array.
        tableView.reloadData()
    }
    
    func loadCategories() {

        // reads all Category Objects from our realm.
        // store the result list to the categories
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    //MARK: - Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
    
        if let category = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(category.items)
                    realm.delete(category)
                }
            } catch {
                print ("Error deleting category, \(error)")
            }
        }
        
    }
    
}
