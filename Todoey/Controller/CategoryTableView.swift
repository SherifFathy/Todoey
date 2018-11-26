//
//  TableViewController.swift
//  Todoey
//
//  Created by Sherif Mahmoud on 11/25/18.
//  Copyright © 2018 Sherif Mahmoud. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableView: UITableViewController {
    
    var categoryList = [Category]()
    let filepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("category.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()

    }
    
    //MARK:- tableView DataSource && Delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryList[indexPath.row].name
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    //MARK:- tableView Delegate && Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toShowList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoTableViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryList[indexPath.row]
        }
    }
    
    //MARK:- Add new Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "Enter the name ,please", preferredStyle: .alert)
        let buttonAction = UIAlertAction(title: "add Category", style: .default) { (addButton) in
            let newItem = Category(context: self.context)
            newItem.name = alertField.text!
            self.categoryList.append(newItem)
            self.saveCategory()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter the Name here!"
            alertField = alertTextField
        }
        
        alert.addAction(buttonAction)
        present(alert , animated: true , completion: nil)
    }
    
    
    
    
    
    //MARK:- saveCategory && loadCategory
    func saveCategory(){
        
        do {
            try context.save()
        } catch  {
            print("error \(error)")
        }
        
    }
    
    func loadCategory(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        do {
            categoryList = try context.fetch(request)
        } catch  {
            print("error \(error)")
        }
        
    }

   


}
