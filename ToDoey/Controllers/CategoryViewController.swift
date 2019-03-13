//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Daniel Cárdenas on 12/03/19.
//  Copyright © 2019 Daniel Cárdenas. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArrey : [Categorys] = [Categorys]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArrey.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let item = categoryArrey[indexPath.row]
        cell.textLabel?.text = item.name
        
        // Ternay operator ==>
        // value = condition? valueIfIsTrue : valueIfIsFalse
        return cell
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Ingresa una categoria", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ingresar", style: .default) { (action) in
            
            print (textfield.text!)
            
            let newCategory = Categorys(context: self.context)
            newCategory.name = textfield.text!
            self.categoryArrey.append(newCategory)
            //self.defaults.set(self.toDoArrey, forKey: "ToDoListArray")
            self.saveFiles()
            
        }
        
        alert.addAction(action)
        alert.addTextField { (alertText) in
            alertText.placeholder = "Ingresa la categoria"
            textfield = alertText
        }
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let destinationVC =  segue.destination as! ToDoViewController
        if let indexPath = tableView.indexPathForSelectedRow {
           destinationVC.selectedCategory = categoryArrey[indexPath.row]
        }
    }
    
    func saveFiles(){
        do {
            try context.save()
        }catch{
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK - extra function
    
    func loadCategories(with request: NSFetchRequest<Categorys> = Categorys.fetchRequest()){
        do {
            categoryArrey = try context.fetch(request)
        }
        catch{
            print ("error retriving the data: \(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK: - Search bat Methods

extension CategoryViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Categorys> = Categorys.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        loadCategories(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadCategories()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
