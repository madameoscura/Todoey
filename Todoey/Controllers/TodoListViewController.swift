//
//  ViewController.swift
//  Todoey
//
//  Created by Annekatrin Dunkel on 9/11/19.
//  Copyright © 2019 Annekatrin Dunkel. All rights reserved.
//

import UIKit

class TodoListViewController : UITableViewController {

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()//file path to our documents directory
        
        print(dataFilePath)

        loadItems()
    }
    
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        
        //Ternary operator ==>
        // value = condition ? valueTrue : valueFalse
        
        //cell.accessoryType = item.done == true ? .checkmark : .none   --> even shorter:
        
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        print(itemArray[indexPath.row])
  
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            //grabbing a reference to the cell that is at a particular index path
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
       
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item buttonon our UIAlert
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
          
            self.saveItems()

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
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        //encode data, itemarray, into our propertylist plist
        do {
            //encode data
            let data = try encoder.encode(itemArray)
            //write data to our data file path
            try data.write(to: dataFilePath!)
        }
        catch {
            print("Error encoding item array, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems() {
        
        //try? will turn result of this method into an optional --> therefore we use optional binding to unwrap it safely
        
        if let data = try? Data(contentsOf: dataFilePath!) {
        let decoder = PropertyListDecoder()
            //method that decodes our data from dataFilePath
            do { itemArray = try decoder.decode([Item].self, from: data)
            } catch {
             print("Error decoding item array, \(error)")
            }
        }
    }
}



