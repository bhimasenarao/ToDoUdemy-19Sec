//
//  CategoryViewController.swift
//  ToDoUdemy-19Sec
//
//  Created by Bhimasena Patri on 18/12/2017.
//  Copyright © 2017 Bhimasena Patri. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        
    }
    
    //MARK: - Tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        //        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - data  manipulation methods
    
    func loadCategory() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
        
    } // end loadCategory
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving: \(error)")
        }
        
        self.tableView.reloadData()
        
    } // end saveCategory
    
    //MARK: - Delete data from  swipe
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category \(error)")
            }
        }
    }
    
    //MARK: - Add new category
    
    @IBAction func addCategoryTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let ac = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
            self.tableView.reloadData()
        }
        ac.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a Category"
            textField = alertTextField
        }
        ac.addAction(action)
        present(ac, animated: true, completion: nil)
    }
}


