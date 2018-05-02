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

class ReportCViewController: UIViewController, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate, UITextFieldDelegate {
    
    let defaults = UserDefaults.standard
    
    
    // MARK: Fields
    var pickedImage = UIImage()
    let locationManager = CLLocationManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var reportImage: UIImage?
    var reportDate: String?
    var reportLocationStr: String?
    var reportLocationLat: String?
    var reportLocationLon: String?
    var reportMessage: String?
    
    
    
    // MARK: Outlets
    @IBOutlet weak var reportImageView: UIImageView?
    @IBOutlet weak var reportDateLabel: UILabel?
    @IBOutlet weak var reportLocationLabel: UILabel?
    @IBOutlet weak var reportMessageView: UITextView?
    @IBOutlet weak var reportGroupLabel: UITextField?
    @IBOutlet weak var reportChangeRecipientButton: UIButton?
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint?
    
    
    
    // MARK: Actions
    
    @IBAction func goBack() {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @IBAction func sendReport(_ sender: Any) {
        print("Sending Report!", terminator: "\n")
        
        reportMessage = (reportMessageView?.text)!
        
        sendEmail()
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    @IBAction func changeRecipient(_ sender: Any) {
        print("Change/Default button pressed.", terminator: "\n")
        if (reportChangeRecipientButton?.currentTitle == "Default") {
            print("State is Default.", terminator: "\n")
            reportGroupLabel?.text = defaults.object(forKey: "DefaultRecipient") as? String
            reportMessageView?.becomeFirstResponder()
            reportChangeRecipientButton?.setTitle("Change", for: .normal)
        } else if (reportChangeRecipientButton?.currentTitle == "Change") {
            print("State is Change.", terminator: "\n")
            reportGroupLabel?.text = ""
            reportGroupLabel?.becomeFirstResponder()
            reportChangeRecipientButton?.setTitle("Default", for: .normal)
        }
    }
    
    
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ReportCViewController Loaded!", terminator: "\n")
        
        // Image
        reportImage = pickedImage
        reportImageView?.image = reportImage
        let aspectRatioConstraint = NSLayoutConstraint(item: self.reportImageView as Any,
                                                       attribute: .height,
                                                       relatedBy: .equal,
                                                       toItem: self.reportImageView,
                                                       attribute: .width,
                                                       multiplier: (reportImage?.size.height)! / (reportImage?.size.width)!,
                                                       constant: 0)
        reportImageView?.addConstraint(aspectRatioConstraint)
        
        // Date
        reportDate = Date().toString(dateFormat: (defaults.object(forKey: "DateFormat") as? String)!)
        reportDateLabel?.text = reportDate
        
        // Location
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // Group
        self.reportGroupLabel?.text = defaults.object(forKey: "DefaultRecipient") as? String
        
        // Message
        reportMessageView?.text = ""
        reportMessageView?.becomeFirstResponder()
    }
    
    
    
    // MARK: Email Functionality
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject((defaults.object(forKey: "DefaultSubject") as? String)!)
            mail.setToRecipients([(reportGroupLabel?.text)!])
            
            mail.setMessageBody(String(format: "%@\n%@\n\nhttps://www.google.com/maps/search/?api=1&query=%@,%@\n\n%@",
                                       reportDate!, reportLocationStr!, reportLocationLat!, reportLocationLon!, reportMessage!),
                                isHTML: false)
            let imageData: NSData = UIImageJPEGRepresentation(reportImage!, 1.0)! as NSData
            mail.addAttachmentData(imageData as Data, mimeType: "image/jpeg", fileName: "imageName")
            present(mail, animated: false)
        } else {
            print("ERROR in sendEmail()", terminator: "\n")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
    
    // MARK: Keyboard Behavior
    
    func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        var keyboardSize = info[UIKeyboardFrameEndUserInfoKey] as! CGRect
        keyboardSize = (self.reportMessageView?.convert(keyboardSize, from: nil))!
        bottomConstraint?.constant = keyboardSize.size.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reportGroupLabel?.delegate = self
        reportGroupLabel?.returnKeyType = .done
        
        self.view.addSubview(reportGroupLabel!)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        reportMessageView?.becomeFirstResponder()
        return true
    }
    
    
    
    // MARK: Location Services
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        reportLocationLat = String(locValue.latitude)
        reportLocationLon = String(locValue.longitude)
        
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
        fetchCountryAndCity(location: location) { city, state, country in
            print("city:", city)
            print("state:", state)
            print("country:", country)
            self.reportLocationStr = String(format: "%@, %@, %@", city, state, country)
            self.reportLocationLabel?.text = self.reportLocationStr
        }
    }
    
    func fetchCountryAndCity(location: CLLocation, completion: @escaping (String, String, String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print(error)
            } else if let country = placemarks?.first?.country,
                let state = placemarks?.first?.administrativeArea,
                let city = placemarks?.first?.locality {
                completion(city, state, country)
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



