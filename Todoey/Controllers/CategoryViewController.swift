//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Anit Patel on 05/08/2019.
//  Copyright © 2019 TerikLimited. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
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
        
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // if categories is not nil, return the count, otherwise return 1.
        // Nil Coalescing operator.
        //
        return categories?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // if categories is not nil, return the text at the index, otherwise return as default string.
        // Nil Coalescing operator.
        //
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
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
    
}
