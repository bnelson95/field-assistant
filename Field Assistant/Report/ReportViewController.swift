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
    
    //MARK: Fields
    var pickedImage = UIImage()
    
    
    
    //MARK: Outlets
    @IBOutlet weak var cameraStack: UIStackView!
    @IBOutlet weak var libraryStack: UIStackView!
    
    
    
    //MARK: Actions
    @objc func openCameraButton() {
        print("Take Picture button pressed", terminator: "\n")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        }
        self.present(imagePicker, animated: false, completion: nil)
    }
    
    @objc func photoFromLibrary() {
        print("Choose From Library button pressed", terminator: "\n")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        self.present(imagePicker, animated: false, completion: nil)
    }
    
    
    
    //MARK:
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        pickedImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        picker.dismiss(animated: false, completion: nil)
        performSegue(withIdentifier: "imageChosen", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Segue Identifier: " + segue.identifier!, terminator: "\n")
        let vc = segue.destination as? ReportCViewController
        vc?.pickedImage = self.pickedImage
    }
    
    
    
    //MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ReportViewController Loaded!", terminator: "\n")
        
        let cameraGesture = UITapGestureRecognizer(target: self, action: #selector(openCameraButton))
        cameraStack.addGestureRecognizer(cameraGesture)
        
        let libraryGesture = UITapGestureRecognizer(target: self, action: #selector(photoFromLibrary))
        libraryStack.addGestureRecognizer(libraryGesture)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
