//
//  ReportCViewController.swift
//  Field Assistant
//
//  Created by Blake Nelson on 2/28/18.
//  Copyright © 2018 Blake Nelson. All rights reserved.
//

import Foundation
import UIKit

class ReportCViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var newReport: Report?
    
    @IBOutlet weak var reportImageView: UIImageView?
    @IBOutlet weak var reportDateLabel: UILabel?
    @IBOutlet weak var reportLocationLabel: UILabel?
    @IBOutlet weak var reportMessageView: UITextView?
    @IBOutlet weak var reportGroupLabel: UILabel?
    
    @IBAction func sendReport(_ sender: Any) {
        print("Sending Report!", terminator: "\n")
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ReportCViewController Loaded!", terminator: "\n")
        print(newReport?.message as Any, terminator: "\n")
        
        let aspectRatioConstraint = NSLayoutConstraint(item: self.reportImageView as Any,
                                                       attribute: .height,
                                                       relatedBy: .equal,
                                                       toItem: self.reportImageView,
                                                       attribute: .width,
                                                       multiplier: ((UIImage(data: (newReport?.image)!)?.size.height)! / (UIImage(data: (newReport?.image)!)?.size.width)!),
                                                       constant: 0)
        reportImageView?.addConstraint(aspectRatioConstraint)
        
        reportImageView?.image = UIImage(data: (newReport?.image)!)
        reportDateLabel?.text = newReport?.date?.toString(dateFormat: "MMM dd, yyyy")
        reportLocationLabel?.text = newReport?.location
        reportMessageView?.text = newReport?.message
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}



extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
