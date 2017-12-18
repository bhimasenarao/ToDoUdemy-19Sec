//
//  CategoryViewController.swift
//  ToDoUdemy-19Sec
//
//  Created by Bhimasena Patri on 18/12/2017.
//  Copyright © 2017 Bhimasena Patri. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategory()
       
    }
    
    
//MARK: - Tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        saveCategory()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
//MARK: - data  manipulation methods
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error reading file: \(error)")
        }
        
        tableView.reloadData()
        
    } // end loadCategory
    
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("Error saving: \(error)")
        }
        
        self.tableView.reloadData()
        
    } // end saveCategory
    
    
//MARK: - Add new category
    
    @IBAction func addCategoryTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let ac = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            self.categoryArray.append(newCategory)
            self.saveCategory()
            self.tableView.reloadData()
        }
        ac.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a Category"
            textField = alertTextField
        }
        ac.addAction(action)
        present(ac, animated: true, completion: nil)
    }
    
    
    //MARK: - Tableview delegate methods
    
    
    
    
    
}
