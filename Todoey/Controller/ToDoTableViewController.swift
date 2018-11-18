//
//  ViewController.swift
//  Todoey
//
//  Created by Sherif Mahmoud on 11/18/18.
//  Copyright © 2018 Sherif Mahmoud. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
    var itemArray = [item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newItem = item()
        newItem.title = "FirstItem"
        newItem.done = true
        itemArray.append(newItem)
        
        let newItem2 = item()
        newItem2.title = "SeconedItem"
        itemArray.append(newItem2)
        
        
        let newItem3 = item()
        newItem3.title = "ThirdItem"
        itemArray.append(newItem3)
        
        
        if defaults.array(forKey: "todoListArray") != nil {
            itemArray = defaults.array(forKey: "todoListArray") as! [item]
        }
        
    }
    
    //MARK:- Table View DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoeyCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK:- Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- add New ItemButton
    
    @IBAction func addButtonAction(_ sender: Any) {
        
        var alertText = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "Sherif", preferredStyle: .alert)
        
        let actionButton = UIAlertAction(title: "Add New Item", style: .default) { (alertActionButton) in
            
            let newItem = item()
            newItem.title = alertText.text!
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "todoListArray")
            self.tableView.reloadData()
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter the new Item here!"
            alertText = alertTextField
        }
        alert.addAction(actionButton)
        present(alert , animated: true , completion: nil)
    }
    
    
    
    


}

