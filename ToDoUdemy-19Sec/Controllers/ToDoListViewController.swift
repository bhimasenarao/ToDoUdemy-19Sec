//
//  ViewController.swift
//  ToDoUdemy-19Sec
//
//  Created by Bhimasena Patri on 17/12/2017.
//  Copyright © 2017 Bhimasena Patri. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        loadItems()
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark: .none //using the ternary operator ? for if...else...
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    } //END didSelect
    
    //MARK: - Create Add new items
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    } //END addTapped
    
    //MARK: - Save Items
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving! \(error)")
        }
        self.tableView.reloadData()
        
    } //END saveItems
    
    //MARK: - Read or load Items
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let addnlPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addnlPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
//        let compPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
//        request.predicate = predicate
        
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    } //END loadItems
    
} //END of class


//MARK: - Search bar methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()

            }
         tableView.reloadData()
        }
        
    }
    
    
}










