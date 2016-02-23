import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    let manager = FirebaseManager.manager
    let ref = FirebaseManager.manager.ref
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = createFBLoginButtonWithPosition(view.center.x, y: view.center.y)
        button.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        ref.observeAuthEventWithBlock { authData in
//            if let authData = authData {
//                
//                self.manager.handleUserAuthData(authData, withMainQueueCompletionHandler: { user in
//                    self.dismissViewControllerAnimated(true, completion: {
//                        //dismiss?
//                    })
//                })
//            }
//        }
    }
}

