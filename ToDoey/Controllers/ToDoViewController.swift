//
//  ViewController.swift
//  ToDoey
//
//  Created by Daniel Cárdenas on 9/03/19.
//  Copyright © 2019 Daniel Cárdenas. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {

    var toDoArrey : [TodoeyItem] = [TodoeyItem]()
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
//        let newItem = TodoeyItem()
//        newItem.title = "Find Mike"
//        toDoArrey.append(newItem)
        
        //loadItems
        loadItems()
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
        saveFiles()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - New items
    
    @IBAction func addButtonPressd(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Ingresa Un ToDoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ingresar", style: .default) { (action) in
            
            print (textfield.text!)
            
            let newItem = TodoeyItem()
            newItem.title = textfield.text!
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
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(toDoArrey)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error Encoding \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
        let decoder = PropertyListDecoder()
            do{
                toDoArrey = try decoder.decode([TodoeyItem].self, from: data)
            }catch{
                print ("Error cargando datos: \(error)")
            }
        }
    }
    
    
}
 
