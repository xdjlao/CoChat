import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      let button = createFBLoginButtonWithPosition(view.center.x, y: view.center.y)
      button.delegate = self
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkForDismiss", name: "FirebaseAuth", object: nil)
   }
   
   func checkForDismiss() {
      if FirebaseManager.manager.authData != nil {
         dismissViewControllerAnimated(true, completion: nil)
      }
   }
}

