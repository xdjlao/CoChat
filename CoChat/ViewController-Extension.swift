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
}
