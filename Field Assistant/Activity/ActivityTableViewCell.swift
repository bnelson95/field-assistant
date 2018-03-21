//
//  ActivityTableViewCell.swift
//  Field Assistant
//
//  Created by Blake Nelson on 3/20/18.
//  Copyright © 2018 Blake Nelson. All rights reserved.
//

import Foundation
import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "ActivityCell"
    
    // MARK: -
    
    @IBOutlet var activityCellImageView: UIImageView!
    @IBOutlet var activityCellMessageView: UITextView!
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
