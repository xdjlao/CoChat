import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet var logoContainer: UIView!
    @IBOutlet var facebookAuthContainer: UIView!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var signUpButtonContainer: UIView!
    @IBOutlet var loginInEmailContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.checkForDismiss), name: "FirebaseAuth", object: nil)
        setUpUI()
    }
    
    func setUpUI(){
        facebookAuthContainer.backgroundColor = Theme.Colors.DarkButtonColor.color
        facebookAuthContainer.layer.cornerRadius = 10
        loginInEmailContainer.backgroundColor = Theme.Colors.DarkButtonColor.color
        loginInEmailContainer.layer.cornerRadius = 10
        signUpButtonContainer.backgroundColor = Theme.Colors.ButtonColor.color
        signUpButtonContainer.layer.cornerRadius = 10
        view.backgroundColor = Theme.Colors.BackgroundColor.color
        let button = createFBLoginButtonWithPosition(view.center.x, y: facebookAuthContainer.center.y)
        button.delegate = self
        navigationController?.navigationBar.tintColor = Theme.Colors.ButtonColor.color
    }
    
    func keyboardWillShow(){
    }
    
    func keyboardWillHide(){
    }
    
    func checkForDismiss() {
        if FirebaseManager.manager.authData != nil {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

