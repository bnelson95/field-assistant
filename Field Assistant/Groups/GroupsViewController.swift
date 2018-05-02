//
//  GroupsViewController.swift
//  Field Assistant
//
//  Created by Blake Nelson on 2/14/18.
//  Copyright © 2018 Blake Nelson. All rights reserved.
//

import Foundation
import UIKit

class GroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var groups: [Group] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addGroup() {
        print("Add Group", terminator: "\n")
        
        //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let group = Group(context: context)
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add New Group", message: "Enter a name for the group", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text)")
            group.name = (textField?.text)!
            do {
                try self.context.save()
            } catch {
                print("Error saving context \(error)")
            }
            
            //let _ = self.navigationController?.popViewController(animated: true)
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create New Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupsTableViewCell
        
        // Fetch Group
        let group = groups[indexPath.row]
        
        // Configure Cell
        cell.nameLabel?.text = group.name!
        
        //print(group.name, terminator: "\n")
        
        return cell
    }
    
    func getData() {
        do {
            groups = try context.fetch(Group.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        for group in groups {
            print(group.name!, terminator: "\n")
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
