//
//  ProfileLogoutCell.swift
//  CoChat
//
//  Created by Jerry on 3/1/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ProfileLogoutCell: UITableViewCell {
    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet weak var logoutCellView: UIView!
    var superviewWidth:CGFloat!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = Theme.Colors.BackgroundColor.color
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
