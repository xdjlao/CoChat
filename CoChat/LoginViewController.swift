import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet var logoContainer: UIView!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var signUpButtonContainer: UIView!
    @IBOutlet var loginInEmailContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.checkForDismiss), name: "FirebaseAuth", object: nil)
        setUpUI()
    }
    
    func setUpUI(){
        loginInEmailContainer.backgroundColor = Theme.Colors.DarkButtonColor.color
        loginInEmailContainer.layer.cornerRadius = 10
        signUpButtonContainer.backgroundColor = Theme.Colors.ButtonColor.color
        signUpButtonContainer.layer.cornerRadius = 10
        view.backgroundColor = Theme.Colors.BackgroundColor.color
        navigationController?.navigationBar.tintColor = Theme.Colors.ButtonColor.color
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

