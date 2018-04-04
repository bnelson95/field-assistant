//
//  ReportViewController.swift
//  Field Assistant
//
//  Created by Blake Nelson on 2/14/18.
//  Copyright © 2018 Blake Nelson. All rights reserved.
//

import Foundation
import UIKit

class ReportViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var newReport: Report
    
    
    @IBAction func openCameraButton(_ sender: UIButton) {
        print("Take Picture button pressed", terminator: "\n")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        }
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func photoFromLibrary(_ sender: UIButton) {
        print("Choose From Library button pressed", terminator: "\n")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newReport.image = UIImageJPEGRepresentation(pickedImage,1.0)
        }
        picker.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "imageChosen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Segue Identifier: " + segue.identifier!, terminator: "\n")
        let vc = segue.destination as? ReportCViewController
        vc?.newReport = self.newReport
    }
    
    required init?(coder aDecoder: NSCoder) {
        newReport = Report(context: context)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ReportViewController Loaded!", terminator: "\n")
        print(newReport.message as Any, terminator: "\n")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
