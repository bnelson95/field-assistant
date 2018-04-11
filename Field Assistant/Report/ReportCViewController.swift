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

class ReportCViewController: UIViewController, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate {
    
    // MARK:
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
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint?
    
    
    // MARK: Actions
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
        reportDate = getDateTime(date: Date())
        reportDateLabel?.text = reportDate
        
        print(reportDateLabel?.text, terminator: "\n")
        
        // Location
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            //reportLocation is updated when locationManger is called
        }
        
        // Message
        reportMessageView?.text = ""
        reportMessageView?.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // MARK: Email Functionality
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("Field Assistant")
            mail.setToRecipients([(reportGroupLabel?.text)!])
            mail.setMessageBody(String(format: "%@\n%@\n\nhttps://www.google.com/maps/search/?api=1&query=%@,%@\n\n%@",
                                       reportDate!, reportLocationStr!, reportLocationLat!, reportLocationLon!, reportMessage!),
                                isHTML: false)
            let imageData: NSData = UIImageJPEGRepresentation(reportImage!, 1.0)! as NSData
            mail.addAttachmentData(imageData as Data, mimeType: "image/jpeg", fileName: "imageName")
            present(mail, animated: true)
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
    
    func getDateTime(date: Date) -> String {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        return String(format: "%d-%d-%d %d:%d:%d", month, day, year, hour, minutes, seconds)
    }
}



extension Date
{
    func toString( dateFormat format: String ) -> String
    {
        let dateFormatter = DateFormatter()
        //dateFormatter.locale = NSLocale(localeIdentifier: "us") as Locale!
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
