import UIKit
extension UIViewController {
    func convertBooltoInt(bool:Bool) -> Int {
        return bool == true ? 1 : 0
    }
    
    func alertNonUniquePassCode(){
        let alertController = UIAlertController(title: "Your Entry Key is already being used", message: "Please try again or let us make one for you by leaving it empty", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Destructive, handler: nil)
        alertController.addAction(action)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func generateRandomPassCode() -> String {
        let alphaNumerial = "ABCDEFGHIJKLMNOPQRSTUVWXYZ012345678910"
        var finalString = ""
        for _ in 0...2 {
            let randomNumber = arc4random_uniform(UInt32(alphaNumerial.characters.count))
            let index = alphaNumerial.startIndex.advancedBy((Int(randomNumber)))
            let str = alphaNumerial[index]
            finalString = "\(finalString)\(str)"
        }
        return finalString
    }
    
    func allTextFieldsAreFilled(textFields:[UITextField]) -> Bool{
        var allFields = false
        for tF in textFields {
            if tF.text == "" || tF.text == nil  {
                animateTextField(tF) }
            else {
                allFields = true
            }
        }
        if allFields == false {
            return false
        }
        return true
    }
    
    func animateTextField(textField:UITextField){
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            textField.backgroundColor = UIColor.redColor()
            }) { (Bool) -> Void in
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    textField.backgroundColor = Theme.Colors.ForegroundColor.color
                    }, completion: nil)
        }
    }
    
    func passwordsMatch(tF1:UITextField, tF2:UITextField) -> Bool {
        if tF1.text == tF2.text {
            return true
        }
        else {
            animateTextField(tF1)
            animateTextField(tF2)
            return false
        }
    }
    
    func isValidEmail(textField:UITextField) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluateWithObject(textField.text) {
            return true
        }
        else {
            animateTextField(textField)
            return false
        }
    }
}
