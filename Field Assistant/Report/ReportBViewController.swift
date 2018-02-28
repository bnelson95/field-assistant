//
//  ReportBViewController.swift
//  Field Assistant
//
//  Created by Blake Nelson on 2/28/18.
//  Copyright © 2018 Blake Nelson. All rights reserved.
//

import Foundation
import UIKit

class ReportBViewController: UIViewController {
    
    var newReport: Report?
    
    @IBOutlet weak var reportImageView: UIImageView?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ReportCViewController {
            let vc = segue.destination as? ReportCViewController
            vc?.newReport = self.newReport
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ReportBViewController Loaded!", terminator: "\n")
        print(newReport?.message as Any, terminator: "\n")
        
        reportImageView?.image = newReport?.image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
