//
//  ReportBViewController.swift
//  Field Assistant
//
//  Created by Blake Nelson on 2/21/18.
//  Copyright © 2018 Blake Nelson. All rights reserved.
//

import Foundation
import UIKit

class ReportBViewController: UIViewController {
    
    var myImg: UIImageView?
    
    @IBOutlet weak var takenImage: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        takenImage = myImg
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
