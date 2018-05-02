//
//  SettingsViewController.swift
//  Field Assistant
//
//  Created by Blake Nelson on 4/18/18.
//  Copyright © 2018 Blake Nelson. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var dateFormatLabel: UILabel!
    
    @IBAction func goBack() {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @IBAction func changeRecipient() {
        print("Change Default Recipient", terminator: "\n")
        
        let alert = UIAlertController(title: "Change Default Recipient", message: "Enter an email for the default recipient", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = self.defaults.object(forKey: "DefaultRecipient") as? String
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let recipientTextField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(recipientTextField?.text)")
            self.defaults.set((recipientTextField?.text)!, forKey: "DefaultRecipient")
            self.recipientLabel.text = (recipientTextField?.text)!
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changeSubject() {
        print("Change Default Subject", terminator: "\n")
        
        let alert = UIAlertController(title: "Change Default Subject", message: "Enter some text as the default subject", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = self.defaults.object(forKey: "DefaultSubject") as? String
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let subjectTextField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(subjectTextField?.text)")
            self.defaults.set((subjectTextField?.text)!, forKey: "DefaultSubject")
            self.subjectLabel.text = (subjectTextField?.text)!
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changeDateFormat() {
        print("Change Date Format", terminator: "\n")
        
        let formats = ["EEE, MMM dd, yyyy hh:mm a",
                       "EEE, MMM dd, yyyy hh:mm a z",
                       "yyyy-MM-dd HH:mm:ss"]
        
        let alert = UIAlertController(title: "Change Date Format", message: "Please select a format", preferredStyle: .alert)
        
        for format in formats {
            alert.addAction(UIAlertAction(title: Date().toString(dateFormat: format), style: .default, handler: { [weak alert] (_) in
                self.defaults.set(format, forKey: "DateFormat")
                self.dateFormatLabel.text = Date().toString(dateFormat: format)
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let key = self.defaults.object(forKey: "DefaultRecipient") as? String {
            self.recipientLabel.text = key
        } else {
            self.defaults.set(self.recipientLabel.text, forKey: "DefaultRecipient")
        }
        
        if let key = self.defaults.object(forKey: "DefaultSubject") as? String {
            self.subjectLabel.text = key
        } else {
            self.defaults.set(self.subjectLabel.text, forKey: "DefaultSubject")
        }
        
        if let key = self.defaults.object(forKey: "DateFormat") as? String {
            self.dateFormatLabel.text = Date().toString(dateFormat: key)
        } else {
            self.dateFormatLabel.text = Date().toString(dateFormat: "EEE, MMM dd, yyyy hh:mm a")
            self.defaults.set("EEE, MMM dd, yyyy hh:mm a", forKey: "DateFormat")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension Date {
    func toString( dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

