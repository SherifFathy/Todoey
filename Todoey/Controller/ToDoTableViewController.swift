//
//  ViewController.swift
//  Todoey
//
//  Created by Sherif Mahmoud on 11/18/18.
//  Copyright © 2018 Sherif Mahmoud. All rights reserved.
//

import UIKit
import CoreData

class ToDoTableViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category?{
    didSet{
        loadItems()
    }
    }
    
    //let defaults = UserDefaults.standard
    
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("itemStorage.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(filePath)
        // Do any additional setup after loading the view, typically from a nib.
        
        loadItems()
        
//        if defaults.array(forKey: "todoListArray") != nil {
//            itemArray = defaults.array(forKey: "todoListArray") as! [item]
//        }
        
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
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
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
            
            let newItem = Item(context: self.context)
            newItem.title = alertText.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            
           // self.defaults.set(self.itemArray, forKey: "todoListArray")
            self.tableView.reloadData()
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter the new Item here!"
            alertText = alertTextField
        }
        alert.addAction(actionButton)
        present(alert , animated: true , completion: nil)
    }
    
    
    @IBAction func deleteItem(_ sender: Any) {
        
        
        
        
        
    }
    
    //MARK:- savedData && loadData
    
    func saveItems(){
        
       
        do {
            try context.save()
        } catch  {
            print("error \(error)")
        }
        
    }
    
    func loadItems (with request : NSFetchRequest<Item> = Item.fetchRequest() , predicat : NSPredicate? = nil){
        
        let categoryPredicat = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name)!)
        
        if let additionalPredicat = predicat {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicat , predicat!])
        }else{
            request.predicate = categoryPredicat
        }
        
            do {
                itemArray = try context.fetch(request)
            } catch  {
                print("error \(error)")
            }
        tableView.reloadData()
        }
    
}


      //MARK:- Extensions
extension ToDoTableViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicat = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicat
        let sort = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sort]
        loadItems(with : request , predicat: predicat)
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
    
    
}

