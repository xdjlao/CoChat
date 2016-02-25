import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

extension UIViewController {
   func checkIfLoggedIn() -> Bool {
      guard let authData = FirebaseManager.manager.ref.authData else {
         
         presentLoginScreen()
         return false
      }
      return true
   }
   
   func presentLoginScreen() {
      let storyboard = UIStoryboard(name: "Login", bundle: nil)
      guard let loginVC = storyboard.instantiateInitialViewController() as? LoginViewController else { return }
      presentViewController(loginVC, animated: true) {
         self.viewWillAppear(false)
      }
   }
   
   func createFBLoginButtonWithPosition(x: CGFloat, y: CGFloat) -> FBSDKLoginButton {
      let fbLoginButton = FBSDKLoginButton()
      fbLoginButton.center = CGPoint(x: x, y: y)
      fbLoginButton.readPermissions = ["public_profile", "email"]
      view.addSubview(fbLoginButton)
      return fbLoginButton
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
                  self.viewWillAppear(false)
                  if self.isKindOfClass(LoginViewController) {
                     self.dismissViewControllerAnimated(true, completion: { 
                        //
                     })
                  }
               })
            }
         })
      }
   }
   func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
      FirebaseManager.manager.user = User(withDummyName: "Anonymous", dummyProfileImageURL: "none", dummyUID: "none")
      FirebaseManager.manager.ref.unauth()      
      viewDidAppear(true)
   }
}

//@objc protocol FBSDKLoginButtonDelegateConformer: FBSDKLoginButtonDelegate {
//   func createFBLoginButton(withPosition position: (x: CGFloat, y: CGFloat)) -> FBSDKLoginButton
//   func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
//   func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
//   var view: UIView { get set }
//   func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
//}
//
//extension FBSDKLoginButtonDelegateConformer {
//   func presentLoginScreen() {
//      let storyboard = UIStoryboard(name: "Login", bundle: nil)
//      guard let loginVC = storyboard.instantiateInitialViewController() as? LoginViewController else { return }
//      presentViewController(loginVC, animated: true) {
//         //??
//      }
//   }
//   func createFBLoginButton(withPosition position: (x: CGFloat, y: CGFloat)) -> FBSDKLoginButton {
//      let size = view.frame.size
//      let fbLoginButton = FBSDKLoginButton()
//      let fbButtonSize = fbLoginButton.frame.size
//      let frame = CGRect(x: size.width * 0.8 , y: size.height * 0.1, width: fbButtonSize.width, height: fbButtonSize.height)
//      fbLoginButton.frame = frame
//      fbLoginButton.readPermissions = ["public_profile", "email"]
//      view.addSubview(fbLoginButton)
//      return fbLoginButton
//   }
//   func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
//      if let error = error {
//         print("Facebook login failed. Error: \(error)")
//      } else if result.isCancelled {
//         print("Facebook login was cancelled")
//      } else {
//         let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
//         FirebaseManager.manager.ref.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { (error, authData) in
//            if let error = error {
//               print("Login failed with error: \(error)")
//            } else {
//               print("Logged in! \(authData)")
//            }
//         })
//      }
//   }
//   func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
//      FirebaseManager.manager.ref.unauth()
//   }
//}
