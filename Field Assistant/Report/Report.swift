//
//  Report.swift
//  Field Assistant
//
//  Created by Blake Nelson on 2/28/18.
//  Copyright © 2018 Blake Nelson. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class Report {
    var id: Int
    var image: UIImage
    var message: String
    var location: String
    var dateTime: Date
    var group: String
    
    init() {
        self.id = Int(arc4random_uniform(1000))
        self.image = UIImage()
        self.message = "Message Placeholder"
        self.location = "Location Placeholder"
        self.dateTime = Date()
        self.group = "Group Name Placeholder"
    }
    
    func getMessage() -> String {
        return self.message
    }
}
