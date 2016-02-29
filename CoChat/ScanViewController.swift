import UIKit
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
   var captureSession:AVCaptureSession?
   var videoPreviewLayer:AVCaptureVideoPreviewLayer?
   var qrCodeFrameView:UIView?
   var passcodeView = true
   
   @IBOutlet weak var scanViewWrapper: UIView!
   @IBOutlet weak var joinViewWrapper: UIView!
   @IBOutlet weak var passcodeLabel: UITextField!
    @IBOutlet var joinButtonOutlet: UIButton!
    @IBOutlet var passcodeLabelWrapper: UIView!
   
    override func viewDidLoad() {
        setUpUI()
        super.viewDidLoad()
    }
   
   @IBAction func onSwitchPressed(sender: UIBarButtonItem) {
      if passcodeView == true {
         startScan()
         passcodeView = false
      } else {
         stopScan()
         passcodeView = true
      }
   }
    @IBAction func onJoinButtonPressed(sender: UIButton) {
        checkForRoomWithEntryKey(passcodeLabel.text!)
    }
    
    func setUpUI(){
        joinViewWrapper.backgroundColor = Theme.Colors.BackgroundColor.color
        passcodeLabelWrapper.backgroundColor = Theme.Colors.ForegroundColor.color
    }
    
    func startScan() {
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input as AVCaptureInput)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        scanViewWrapper.layer.addSublayer(videoPreviewLayer!)
        
        // Hide scanviewwrapper
        scanViewWrapper.hidden = false
        // Show joinviewwrapper
        joinViewWrapper.hidden = true
        
        // Start video capture.
        captureSession?.startRunning()
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
    }
    
    func stopScan() {
        captureSession?.stopRunning()
        joinViewWrapper.hidden = false
        scanViewWrapper.hidden = true
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            print("No QR code is detected")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                checkForRoomWithEntryKey(metadataObj.stringValue)
            }
        }
    }
    
    func checkForRoomWithEntryKey(key: String) {
        FirebaseManager.manager.getObjectsByChildValue(Room(), childProperty: "entryKey", childValue: key) { rooms in
            guard let room = rooms?[0] else { return }
            
            FirebaseManager.manager.getChildrenForParent(Channel(), parent: room) { channels in
                guard let channels = channels else { return }
                room.channels = channels
                self.performSegueWithSegueIdentifier(.SegueToMessaging, sender: room)
            }
        }
    }
    
    func checkForRoomWithUID(uid: String) {
        FirebaseManager.manager.getObjectForID(Room(), uid: uid) { room in
            guard let room = room else { return }
            
            FirebaseManager.manager.getChildrenForParent(Channel(), parent: room) { channels in
                guard let channels = channels else { return }
                room.channels = channels
                self.performSegueWithSegueIdentifier(.SegueToMessaging, sender: room)
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.SegueToMessaging.rawValue {
            guard let nvc = segue.destinationViewController as? MessagingNavigationViewController else { return }
            guard let mvc = nvc.topViewController as? MessagingViewController else { return }
            guard let room = sender as? Room else { return }
            mvc.room = room
            mvc.currentChannel = room.channels[0]
        }
    }
}
