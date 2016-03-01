//
//  ProfileHeaderCell.swift
//  CoChat
//
//  Created by Jerry on 2/28/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileHeaderCell: UITableViewCell {
    
    var user: User? {
        didSet {
            
            let profileURL = NSURL(string: (user?.profileImageURL)!)
            
            userImageView.setImageWithURL(profileURL!, placeholderImage: UIImage(named: "dummyProfileImage"))
            userImageView.layer.cornerRadius = userImageView.frame.size.width/2
            userImageView.clipsToBounds = true
            usernameLabel.text = user!.name
        }
    }

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        usernameLabel.font = Theme.Fonts.BoldNormalTypeFace.font
        usernameLabel.textColor = UIColor.whiteColor()
        backgroundColor = Theme.Colors.NavigationBarColor.color
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
