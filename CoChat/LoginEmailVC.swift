import Firebase
import UIKit

class LoginEmailVC: UIViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var logInButton: UIButton!
    @IBOutlet var logInButtonContainer: UIView!
    var textFields:[UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    func setUpUI(){
        textFields.appendContentsOf([emailTextField, passwordTextField])
        for tF in textFields {
            tF.backgroundColor = Theme.Colors.ForegroundColor.color
            tF.delegate = self
            tF.alpha = 0.5
            tF.textColor = UIColor.whiteColor()
            let placeholderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            tF.attributedPlaceholder = NSAttributedString(string: tF.placeholder!, attributes: [NSForegroundColorAttributeName : placeholderColor])
            tF.layer.cornerRadius = 10
        }
        logInButton.backgroundColor = UIColor.clearColor()
        logInButtonContainer.backgroundColor = Theme.Colors.ButtonColor.color
        logInButtonContainer.layer.cornerRadius = 10
        view.backgroundColor = Theme.Colors.BackgroundColor.color
        
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(LoginEmailVC.handleSingleTap(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func handleSingleTap(sender: UITapGestureRecognizer){
        if sender.state == .Ended {
            view.endEditing(true)
        }
    }
    
    @IBAction func logInButtonWasTapped(sender: UIButton) {
        if allTextFieldsAreFilled(textFields) && isValidEmail(emailTextField) {
            let ref = FirebaseManager.manager.ref
            
            ref.authUser(emailTextField.text!, password: passwordTextField.text!, withCompletionBlock: { error, authData in
                if let error = error {
                    print(error)
                }
                guard let authData = authData else { return }
                FirebaseManager.manager.handleUserAuthData(authData, name: nil, withMainQueueCompletionHandler: { user in
                    //
                })
            })
        }
    }
}

extension LoginEmailVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.alpha = 1.0
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
