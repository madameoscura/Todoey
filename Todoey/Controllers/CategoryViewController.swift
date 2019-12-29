//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Annekatrin Dunkel on 9/13/19.
//  Copyright © 2019 Annekatrin Dunkel. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    //initializing a new accesspoint to our realm database. The first time a realm instance is created can fail if resources are limited, therefore try!
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none
        
    }
    //MARK: - TableView Datasource Methods
    
    //returns number of categories
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if categories is not nil return count, if not return 1
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //reference to cell 
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
                if let category = categories?[indexPath.row] {
                    cell.textLabel?.text = category.name
                    
                    guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
                    cell.backgroundColor = categoryColour
                    cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
                }

        //we need to return cell again because we modified it from super class
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        //what is the selected cell/category:
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    //here we read our data in database
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData() //calls all of the datasource methods again
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)}
            } catch {
                print("Error deleting category \(error)")
            }
        }
    }
    //MARK: - AddNew Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            //string that appears in grey and disappears when user clicks on it
            textField.placeholder = "Add a new category"
            textField = field
        }
        
        present(alert, animated: true, completion: nil)
        //show our alert
        
    }
    
}

