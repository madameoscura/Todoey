//
//  ViewController.swift
//  Todoey
//
//  Created by Annekatrin Dunkel on 9/11/19.
//  Copyright © 2019 Annekatrin Dunkel. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController : SwipeTableViewController {
    
    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()//file path to our documents directory
        
        tableView.separatorStyle = .none

    }
    
    //gets called later than viewDidLoad, when view loads, navigationController is not in navigation stack yet, this is why app crashed when we tried to call method in viewDidLoad
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name

        guard let colourHex = selectedCategory?.colour else { fatalError() }

        updateNavBar(withHexCode: colourHex)
    }
    
    //gets called when view is just about to be removed and current view controller gets destroyed
    override func viewWillDisappear(_ animated: Bool) {
 
        updateNavBar(withHexCode: "67B3C5")
    }
    
    //MARK: - NavBar Setup Methods
    
    func updateNavBar (withHexCode colourHexCode: String) {
         guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist")}
        
        guard let navbarColour = UIColor(hexString: colourHexCode) else { fatalError()}
        
        navBar.barTintColor = navbarColour
        
        navBar.tintColor = ContrastColorOf(navbarColour, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navbarColour, returnFlat: true)]
        
        searchBar.barTintColor = navbarColour
    }
    
    //MARK: - Tableview Datasource Methods
    
    //we should have as many cells as we have todo items for our current selected category
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            

            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                }

//            print ("version 1 : \(CGFloat(indexPath.row / todoItems!.count))")
//            print ("version 2 : \(CGFloat(indexPath.row) / CGFloat(todoItems!.count))")
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }

        //we need to return cell again because we modified it from super class
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
 //                   realm.delete(item) --> if I want to delete instead of checking
                   item.done = !item.done }
                } catch {
                    print("Error saving done status \(error)")
                }
            }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        
        alert.addTextField { (alertTextField) in
            //string that appears in grey and disappears when user clicks on it
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        //show our alert
        
    }
    
    //MARK: - Model manipulation methods
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        //reload tableView to call datasource methods
        tableView.reloadData()
    }
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)}
            } catch {
                print("Error deleting item \(error)")
            }
        }
    }
    
}

//MARK: - Search bar methods

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    //what happens when we dismiss searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
        }

        DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
        }
    }

}
