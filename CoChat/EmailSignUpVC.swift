import UIKit
import Firebase

class EmailSignUpVC: UIViewController, UITextFieldDelegate {
    @IBOutlet var formContainer: UIView!
    @IBOutlet var signUpButtonContainer: UIView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var fullNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var rePasswordTextField: UITextField!

    @IBOutlet var signUpButton: UIButton!
    var activeTextField:UITextField?
    var textFields:[UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields.appendContentsOf([emailTextField, fullNameTextField, passwordTextField, rePasswordTextField])
        setUpUI()
    }
    
    func setUpUI(){
        for tF in textFields {
            tF.backgroundColor = Theme.Colors.ForegroundColor.color
            tF.layer.cornerRadius = 10
            tF.delegate = self
            let placeholderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            tF.attributedPlaceholder = NSAttributedString(string: tF.placeholder!, attributes: [NSForegroundColorAttributeName : placeholderColor])
        }
        formContainer.backgroundColor = UIColor.clearColor()
        signUpButtonContainer.backgroundColor = Theme.Colors.ButtonColor.color
        signUpButtonContainer.layer.cornerRadius = 10
        signUpButton.backgroundColor = UIColor.clearColor()
        view.backgroundColor = Theme.Colors.BackgroundColor.color
        
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(EmailSignUpVC.handleSingleTap(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func handleSingleTap(sender: UITapGestureRecognizer){
        if sender.state == .Ended {
            view.endEditing(true)
        }
    }
    
    @IBAction func signUpButtonWasTapped(sender: UIButton) {
        if allTextFieldsAreFilled(textFields) && passwordsMatch(passwordTextField, tF2: rePasswordTextField)
            && isValidEmail(emailTextField) {
            
            let ref = Firebase(url: "https://najchat.firebaseio.com/")
            ref.createUser(emailTextField.text!, password: passwordTextField.text!, withValueCompletionBlock: { error, result in
                if let error = error {
                    print(error)
                } else {
                    ref.authUser(self.emailTextField.text!, password: self.passwordTextField.text!, withCompletionBlock: { error, authData in
                        FirebaseManager.manager.handleUserAuthData(authData, name: self.fullNameTextField.text!, withMainQueueCompletionHandler: { user in
                            print("new user \(user) authed")
                        })
                    })
                }
            })
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.alpha = 1.0
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            textField.alpha = 0.5
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
