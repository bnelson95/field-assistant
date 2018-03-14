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
    
    @IBAction func openCameraButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func photoFromLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //myImageView.image = pickedImage
            newReport.image = UIImagePNGRepresentation(pickedImage)
            //newReport.imageView.contentMode = .scaleToFill
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ReportBViewController {
            let vc = segue.destination as? ReportBViewController
            vc?.newReport = self.newReport
        }
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
