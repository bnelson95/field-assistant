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
    
    var newReport: Report?
    
    @IBOutlet weak var reportImageView: UIImageView?
    @IBOutlet weak var reportMessageView: UITextView?
    
    @IBAction func sendReport(_ sender: Any) {
        print("Sending Report!", terminator: "\n")
        
        
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
                                                       multiplier: ((newReport?.image.size.height)! / (newReport?.image.size.width)!),
                                                       constant: 0)
        reportImageView?.addConstraint(aspectRatioConstraint)
        
        reportImageView?.image = newReport?.image
        reportMessageView?.text = newReport?.message
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
