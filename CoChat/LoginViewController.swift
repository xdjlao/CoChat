import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = createFBLoginButtonWithPosition(view.center.x, y: view.center.y)
        button.delegate = self
    }
}

