import UIKit
import Firebase

extension UIViewController {
    
    func presentLoginScreen() {

        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        guard let loginVC = storyboard.instantiateInitialViewController() as? LoginNavigationVC else { return }
        presentViewController(loginVC, animated: true, completion: nil)
    }
    
}
