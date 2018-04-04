//
//  ReportBViewController.swift
//  Field Assistant
//
//  Created by Blake Nelson on 2/28/18.
//  Copyright © 2018 Blake Nelson. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class ReportBViewController: UIViewController, CLLocationManagerDelegate {
    
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
        
        let aspectRatioConstraint = NSLayoutConstraint(item: self.reportImageView as Any,
                                                       attribute: .height,
                                                       relatedBy: .equal,
                                                       toItem: self.reportImageView,
                                                       attribute: .width,
                                                       multiplier: ((UIImage(data: (newReport?.image)!)?.size.height)! / (UIImage(data: (newReport?.image)!)?.size.width)!),
                                                       constant: 0)
        reportImageView?.addConstraint(aspectRatioConstraint)
        
        reportImageView?.image = UIImage(data: (newReport?.image)!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
