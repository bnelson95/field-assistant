//
//  GroupsViewController.swift
//  Field Assistant
//
//  Created by Blake Nelson on 2/14/18.
//  Copyright © 2018 Blake Nelson. All rights reserved.
//

import Foundation
import UIKit

class GroupsViewController: UIViewController {
    
    var groups = [Group]()
    
    @IBAction func addGroup() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension GroupsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupsTableViewCell.reuseIdentifier, for: indexPath) as? GroupsTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        // Fetch Quote
        let group = groups[indexPath.row]
        
        // Configure Cell
        cell.nameLabel.text = group.name
        cell.countLabel.text = String(groups.count)
        
        return cell
    }
    
}

