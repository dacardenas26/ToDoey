//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Daniel Cárdenas on 12/03/19.
//  Copyright © 2019 Daniel Cárdenas. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArrey : Results<Categorys>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArrey?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let item = categoryArrey?[indexPath.row]
        cell.textLabel?.text = item?.name ?? "no hay categorias todavia"
        
        // Ternay operator ==>
        // value = condition? valueIfIsTrue : valueIfIsFalse
        return cell
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Ingresa una categoria", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ingresar", style: .default) { (action) in
            
            print (textfield.text!)
            
            let newCategory = Categorys()
            newCategory.name = textfield.text!
            self.save(categorys: newCategory)
            
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
           destinationVC.selectedCategory = categoryArrey?[indexPath.row]
        }
    }
    
    func save(categorys: Categorys){
        do {
            try realm.write {
                realm.add(categorys)
                }
        }catch{
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK - extra function
    
    func loadCategories(){
        categoryArrey = realm.objects(Categorys.self)
        tableView.reloadData()
    }
    
}

//MARK: - Search bat Methods

extension CategoryViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        categoryArrey = categoryArrey?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
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
