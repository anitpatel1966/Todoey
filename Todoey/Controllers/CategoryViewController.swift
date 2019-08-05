//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Anit Patel on 05/08/2019.
//  Copyright © 2019 TerikLimited. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    //
    // get the viewContext using the singleton UIApplication.shared that represents the AppDelegate object.
    //
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


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
        
        return categoryArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
        
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    

    //MARK: - Add new categories
    //
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert )
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            // Create the Category within the context, and later add it to the array. Then save the context using function.
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
            
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
    
    func saveCategories() {
        
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
    //
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        // fetch back data of type Item using the
        // request passed in
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print ("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
}
