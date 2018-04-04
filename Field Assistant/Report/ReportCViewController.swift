//
//  ReportCViewController.swift
//  Field Assistant
//
//  Created by Blake Nelson on 2/28/18.
//  Copyright © 2018 Blake Nelson. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import MapKit
import CoreLocation

class ReportCViewController: UIViewController, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate
{
    let locationManager = CLLocationManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var newReport: Report?
    
    @IBOutlet weak var reportImageView: UIImageView?
    @IBOutlet weak var reportDateLabel: UILabel?
    @IBOutlet weak var reportLocationLabel: UILabel?
    @IBOutlet weak var reportMessageView: UITextView?
    @IBOutlet weak var reportGroupLabel: UITextField?
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint?
    
    @IBAction func sendReport(_ sender: Any) {
        print("Sending Report!", terminator: "\n")
        
        sendEmail()
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("Field Assistant")
            mail.setToRecipients([(reportGroupLabel?.text)!])
            mail.setMessageBody(String(format: "%@\n\nhttps://www.google.com/maps/search/?api=1&query=%@,%@\n\n%@",
                                       (newReport?.date?.toString(dateFormat: "MMM dd, yyyy HH:mm:ss"))!,
                                       (newReport?.latitude)!,
                                       (newReport?.longitude)!,
                                       (reportMessageView?.text)!),
                                isHTML: false)
            let imageData: NSData = UIImageJPEGRepresentation(UIImage(data: (newReport?.image)!)!, 1.0)! as NSData
            mail.addAttachmentData(imageData as Data, mimeType: "image/jpeg", fileName: "imageName")
            present(mail, animated: true)
        } else {
            print("ERROR in sendEmail()", terminator: "\n")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ReportCViewController Loaded!", terminator: "\n")
        print(newReport?.message as Any, terminator: "\n")
        
        
        
        
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
        newReport?.date = Date()
        
        
        let aspectRatioConstraint = NSLayoutConstraint(item: self.reportImageView as Any,
                                                       attribute: .height,
                                                       relatedBy: .equal,
                                                       toItem: self.reportImageView,
                                                       attribute: .width,
                                                       multiplier: ((UIImage(data: (newReport?.image)!)?.size.height)! / (UIImage(data: (newReport?.image)!)?.size.width)!),
                                                       constant: 0)
        reportImageView?.addConstraint(aspectRatioConstraint)
        
        reportImageView?.image = UIImage(data: (newReport?.image)!)
        reportDateLabel?.text = newReport?.date?.toString(dateFormat: "MMM dd, yyyy HH:mm:ss")
        reportLocationLabel?.text = String(format: "%@\n%@", (newReport?.latitude)!, (newReport?.longitude)!)
        reportMessageView?.text = newReport?.message
    }
    
    func textFieldShouldReturn(textField: UITextView) -> Bool {
        self.reportMessageView?.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        bottomConstraint?.constant = keyboardSize
        
        let duration: TimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        let info = sender.userInfo!
        let duration: TimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        bottomConstraint?.constant = 20
        
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        newReport?.latitude = String(locValue.latitude)
        newReport?.longitude = String(locValue.longitude)
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
