//
//  ViewController.swift
//  Field Assistant
//
//  Created by Blake Nelson on 2/14/18.
//  Copyright © 2018 Blake Nelson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   
    @IBOutlet weak var op1: UITextField!
    @IBOutlet weak var op2: UITextField!
    @IBOutlet weak var result: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func calculate(_ sender: Any) {
        let text1: String = op1.text!
        let text2: String = op2.text!
        
        let num1: Int! = Int(text1)
        let num2: Int! = Int(text2)
        let resultNum = num1 + num2
        
        let resultText = String(resultNum)
        result.text = resultText
    }

}

