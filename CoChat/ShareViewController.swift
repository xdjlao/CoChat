import UIKit
import Social

class ShareViewController: UIViewController {
    
    @IBOutlet var QRImageView: UIImageView!
    @IBOutlet weak var shareItemLabel: UILabel!
    @IBOutlet weak var shareItemSegmentedControl: UISegmentedControl!
    @IBOutlet weak var facebookButtonOutlet: UIButton!
    @IBOutlet weak var twitterButtonOutlet: UIButton!
    
    var channel:Channel?
    var room:Room?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateQRCode()
        showShareItem()
        navigationItem.title = "Share"
        
    }
    
    func launchUniversalLink(){
        // do something
    }
    
    func showShareItem() {
        if shareItemSegmentedControl.selectedSegmentIndex == 0 {
            guard let channelPasscode = room?.password else {return}
            shareItemLabel.text = channelPasscode
        } else if shareItemSegmentedControl.selectedSegmentIndex == 1 {
            let channelItem = "blndr://room/\(room!.password)"
            shareItemLabel.text = channelItem
        }
    }
    
    
    func generateQRCode() {
        guard let channelPassCode = room?.password else {return}
        
        let data = channelPassCode.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator"){
            
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("Q", forKey: "inputCorrectionLevel")
            
            if let qrCodeImage = filter.outputImage {
                displayQRCodeImage(qrCodeImage)
            }
        }
    }
    
    func displayQRCodeImage(ciImage:CIImage) {
        let scaleX = QRImageView.frame.size.width / ciImage.extent.size.width
        let scaleY = QRImageView.frame.size.height / ciImage.extent.size.height
        
        let transformedImage = ciImage.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))
        
        QRImageView.image = UIImage(CIImage: transformedImage)
        
    }
    
    @IBAction func onSaveImage(sender: UIButton) {
        //UIImageWriteToSavedPhotosAlbum(QRImageView.image!, self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
        screenShotMethod()
    }
    
    func screenShotMethod() {
        //Create the UIImage
        UIGraphicsBeginImageContext(QRImageView.frame.size)
        QRImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(screenshot, self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafePointer<()>) {
        dispatch_async(dispatch_get_main_queue(), {
            let alert = UIAlertController(title: "Success", message: "This QR Code has been saved to your Camera Roll", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    @IBAction func onShareItemSegmentedControlChanged(sender: UISegmentedControl) {
        showShareItem()
    }
    
    @IBAction func onCopy(sender: UIButton) {
        copyText(shareItemLabel.text!) { () -> () in
            let alert = UIAlertController(title: "Passcode Copied!", message: "Now share it with the world", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func copyText(textString:String, completion:() -> ()) {
        let copy = UIPasteboard.generalPasteboard()
        copy.string = textString
        completion()
    }
    
    @IBAction func onFacebookButtonPressed(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            self.presentViewController(fbShare, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func onTwitterButtonPressed(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            
            let tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            self.presentViewController(tweetShare, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}