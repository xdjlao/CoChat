import UIKit
import Social

class ShareViewController: UIViewController {
    
    @IBOutlet weak var qrViewWrapper: UIView!
    @IBOutlet var QRImageView: UIImageView!
    @IBOutlet weak var shareItemLabel: UILabel!
    @IBOutlet weak var shareItemSegmentedControl: UISegmentedControl!
    @IBOutlet weak var facebookButtonOutlet: UIButton!
    @IBOutlet weak var twitterButtonOutlet: UIButton!
    @IBOutlet weak var copyButtonOutlet: UIButton!
    
    var channel:Channel?
    var room:Room?
    var copied:String!
    let baseURL = "https://blendchat.herokuapp.com/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        generateQRCode()
        showShareItem()
        navigationItem.title = "Share"
        qrViewWrapper.backgroundColor = Theme.Colors.NavigationBarColor.color
        setSocialIcons()
        (shareItemSegmentedControl.subviews[0] as UIView).tintColor = UIColor.whiteColor()
        (shareItemSegmentedControl.subviews[1] as UIView).tintColor = UIColor.whiteColor()
    }
    
    func launchUniversalLink(){
        // do something
    }
    
    func showShareItem() {
        if shareItemSegmentedControl.selectedSegmentIndex == 0 {
            let channelItem = baseURL+room!.password
            copied = "Link"
            shareItemLabel.text = channelItem
        } else if shareItemSegmentedControl.selectedSegmentIndex == 1 {
            guard let channelPasscode = room?.password else {return}
            copied = "Passcode"
            shareItemLabel.text = channelPasscode
        }
    }
    
    func setSocialIcons() {
        facebookButtonOutlet.layer.cornerRadius = facebookButtonOutlet.frame.size.width/2
        twitterButtonOutlet.layer.cornerRadius = twitterButtonOutlet.frame.size.width/2
        copyButtonOutlet.layer.cornerRadius = copyButtonOutlet.frame.size.width/2
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
        let tapGesture = UITapGestureRecognizer(target: self, action: "onImageTapped:")
        QRImageView.addGestureRecognizer(tapGesture)
    }

    @IBAction func onSaveImage(sender: UIButton) {
        //UIImageWriteToSavedPhotosAlbum(QRImageView.image!, self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
        screenShotMethod()
    }
    
    func onImageTapped(sender: UITapGestureRecognizer) {
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
            let alert = UIAlertController(title: "\(self.copied) Copied!", message: "Now share it with the world", preferredStyle: UIAlertControllerStyle.Alert)
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
            fbShare.setInitialText("Hello from Facebook")
            
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
            if shareItemSegmentedControl.selectedSegmentIndex == 0 {
                let channelItem = "\(room!.title) link - \(baseURL+room!.password)"
                let initialText = channelItem
                tweetShare.setInitialText(initialText)
            } else if shareItemSegmentedControl.selectedSegmentIndex == 1 {
                let channelPasscode = "\(room!.title) entry passcode - \(room!.password)"
                let initialText = channelPasscode
                tweetShare.setInitialText(initialText)
            }
            
            self.presentViewController(tweetShare, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}