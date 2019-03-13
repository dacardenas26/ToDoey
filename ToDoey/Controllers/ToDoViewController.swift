//
//  ViewController.swift
//  ToDoey
//
//  Created by Daniel Cárdenas on 9/03/19.
//  Copyright © 2019 Daniel Cárdenas. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController {

    var toDoArrey : [Item] = [Item]()
    //let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var selectedCategory : Categorys? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
//        let newItem = TodoeyItem()
//        newItem.title = "Find Mike"
//        toDoArrey.append(newItem)
        
        //loadItems
    }
    
    // MARK - Table View Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArrey.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = toDoArrey[indexPath.row]
        cell.textLabel?.text = item.title
        
        // Ternay operator ==>
        // value = condition? valueIfIsTrue : valueIfIsFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print (indexPath.row)
//        print (toDoArrey[indexPath.row])
        
        toDoArrey[indexPath.row].done = !toDoArrey[indexPath.row].done

        //Borrar items, importante el orden
//        context.delete(toDoArrey[indexPath.row])
//        toDoArrey.remove(at: indexPath.row)
        
        saveFiles()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - New items
    
    @IBAction func addButtonPressd(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Ingresa Un ToDoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ingresar", style: .default) { (action) in
            
            print (textfield.text!)
            
            let newItem = Item(context: self.context)
            newItem.title = textfield.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.toDoArrey.append(newItem)
            //self.defaults.set(self.toDoArrey, forKey: "ToDoListArray")
            self.saveFiles()
            
        }
        
        alert.addAction(action)
        alert.addTextField { (alertText) in
            alertText.placeholder = "Ingresa un recordatorio"
            textfield = alertText
        }
        present(alert, animated: true, completion: nil)
    }
    
    func saveFiles(){
        do {
           try context.save()
        }catch{
            print("Error saving \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let setPredicate = predicate {
            request.predicate = NSCompoundPredicate (andPredicateWithSubpredicates: [categoryPredicate,setPredicate])
        }else{
            request.predicate = categoryPredicate
        }
       
        do {
            toDoArrey = try context.fetch(request)
        }
        catch{
            print ("error retriving the data: \(error)")
        }
        tableView.reloadData()
    }
    

    
}

//MARK: - Search bat Methods

extension ToDoViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
 
