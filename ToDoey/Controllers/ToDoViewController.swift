//
//  ViewController.swift
//  ToDoey
//
//  Created by Daniel Cárdenas on 9/03/19.
//  Copyright © 2019 Daniel Cárdenas. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoViewController: UITableViewController {
    
    let realm = try! Realm()
    var todoItems : Results<Item>?

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
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none ?? .none
        }else{
         cell.textLabel?.text = "no hay ToDoes"
        }
        return cell
    }
    
    //MARK - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row]{
            do{
            try realm.write {
                item.done = !item.done
            }
            }catch{
                print ("error cambiando el estado de la celda \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - New items
    
    @IBAction func addButtonPressd(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Ingresa Un ToDoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ingresar", style: .default) { (action) in
            if let currentCategory = self.selectedCategory{
            
                do{
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textfield.text!
                    newItem.date = Date()
                    currentCategory.items .append(newItem)
                    }
                }catch{
                    print (error)
                }
            }
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (alertText) in
            alertText.placeholder = "Ingresa un recordatorio"
            textfield = alertText
        }
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    

    
}

//MARK: - Search bat Methods

extension ToDoViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
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

