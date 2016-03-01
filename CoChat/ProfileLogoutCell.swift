//
//  ProfileLogoutCell.swift
//  CoChat
//
//  Created by Jerry on 3/1/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ProfileLogoutCell: UITableViewCell, FBSDKLoginButtonDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let size = frame.size
        let button = createFBLoginButtonWithPosition(size.width * 0.8, y: size.height * 0.1)
        button.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func createFBLoginButtonWithPosition(x: CGFloat, y: CGFloat) -> FBSDKLoginButton {
        let fbLoginButton = FBSDKLoginButton()
        fbLoginButton.center = CGPoint(x: x, y: y)
        fbLoginButton.readPermissions = ["public_profile", "email"]
        addSubview(fbLoginButton)
        return fbLoginButton
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        FirebaseManager.manager.user = User(withDummyName: "Anonymous", dummyProfileImageURL: "none", dummyUID: "none")
        FirebaseManager.manager.ref.unauth()
        FirebaseManager.manager.authData = nil
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if let error = error {
            print("Facebook login failed. Error: \(error)")
        } else if result.isCancelled {
            print("Facebook login was cancelled")
        } else {
            let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
            FirebaseManager.manager.ref.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                if let error = error {
                    print("Login failed with error: \(error)")
                } else {
                    print("Logged in! \(authData)")
                    FirebaseManager.manager.handleUserAuthData(authData, withMainQueueCompletionHandler: { user in
                        //self.dismissViewControllerAnimated(true, completion: nil)
                    })
                }
            })
        }
    }
}
