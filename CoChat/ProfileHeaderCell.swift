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
      print(__FUNCTION__)
      let profileURL = NSURL(string: (FirebaseManager.manager.user.profileImageURL))
      userImageView.setImageWithURL(profileURL!, placeholderImage: UIImage(named: "dummyProfileImage"))
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
      
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "setUIforUser", name: UIApplicationDidBecomeActiveNotification, object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "setUIforUser", name: "FirebaseAuth", object: nil)
   }
   
   deinit {
      print("hi jerry")
      NSNotificationCenter.defaultCenter().removeObserver(self)
   }
}
