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
    
    func setUIforUser() {
        print(#function)
        let profileURL = NSURL(string: (FirebaseManager.manager.user.profileImageURL))
        if profileURL != "none" {
           userImageView.setImageWithURL(profileURL!, placeholderImage: UIImage(named: "profileImageDummy"))
        } else {
            userImageView.image = UIImage(named: "profileImageDummy")
        }
        userImageView.layer.cornerRadius = userImageView.frame.size.width/2
        userImageView.clipsToBounds = true
        usernameLabel.text = FirebaseManager.manager.user.name
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        usernameLabel.font = Theme.Fonts.BoldNormalTypeFace.font
        usernameLabel.textColor = UIColor.whiteColor()
        backgroundColor = Theme.Colors.NavigationBarColor.color
        
        setUIforUser()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileHeaderCell.setUIforUser), name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileHeaderCell.setUIforUser), name: "FirebaseAuth", object: nil)
    }
    
    deinit {
        print("hi jerry")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
