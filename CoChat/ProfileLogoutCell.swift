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
    
    @IBOutlet weak var logoutCellView: UIView!
    var profileLogoutButton:FBSDKLoginButton? {
        didSet {
            if let logout = profileLogoutButton {
                logout.frame = logoutCellView.frame
                logoutCellView.addSubview(logout)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
