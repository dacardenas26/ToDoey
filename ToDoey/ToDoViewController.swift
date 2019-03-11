//
//  ViewController.swift
//  ToDoey
//
//  Created by Daniel Cárdenas on 9/03/19.
//  Copyright © 2019 Daniel Cárdenas. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {

    var toDoArrey = ["Empacar","sacar basura","trastear"]
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let item = defaults.array(forKey: "ToDoListArray") as? [String]{
            toDoArrey = item
        }
    }
    
    // MARK - Table View Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArrey.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = toDoArrey[indexPath.row]
        return cell
    }
    
    //MARK - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print (indexPath.row)
//        print (toDoArrey[indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - New items
    
    @IBAction func addButtonPressd(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Ingresa Un ToDoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ingresar", style: .default) { (action) in
            print (textfield.text!)
            self.toDoArrey.append(textfield.text!)
            self.defaults.set(self.toDoArrey, forKey: "ToDoListArray")
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        alert.addTextField { (alertText) in
            alertText.placeholder = "Ingresa un recordatorio"
            textfield = alertText
        }
        present(alert, animated: true, completion: nil)
    }
    
}
 
