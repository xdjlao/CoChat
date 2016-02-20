import UIKit

class ShareViewController: UIViewController {
    @IBOutlet var roomLabel: UILabel!
    @IBOutlet var QRImageView: UIImageView!
    var room:Room?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateQRCode()
        navigationItem.title = room?.title
        roomLabel.text = room?.password
    }
    
    func launchUniversalLink(){
        // do something
    }
    
    
    func generateQRCode() {
        guard let roomPassCode = room?.password else {return}
        
        let data = roomPassCode.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
        
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
    
    
}