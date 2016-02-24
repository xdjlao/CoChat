import UIKit
import FBSDKCoreKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    override init() {
        super.init()
        Firebase.defaultConfig().persistenceEnabled = true
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseManager.manager.ref.observeAuthEventWithBlock { authData in
            if let authData = authData {
                FirebaseManager.manager.handleUserAuthData(authData, withMainQueueCompletionHandler: nil)
            }
         print("facebook ref observeAuthEventWithBlock")
        }
        //      FirebaseManager.manager.ref.unauth()
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
   
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        guard let host = url.host else { return false }
        guard let roomID = url.pathComponents else { return false }
        if host == "room" && !roomID.isEmpty {
            FirebaseManager.manager.checkForRoomWithEntryKey(roomID[1], completionHandler: { (room) -> () in
    
                let messageStoryboardNavigation = UIStoryboard(name: "Main", bundle: nil)
                let rootViewController = messageStoryboardNavigation.instantiateViewControllerWithIdentifier("MessengerNavigationController") as? UINavigationController
                let destinationViewController = rootViewController?.topViewController as! MessagingViewController
                destinationViewController.room = room
                destinationViewController.currentChannel = room!.channels[0]
                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                self.window!.rootViewController = rootViewController
                self.window!.makeKeyAndVisible()
                
            })
        }
        
        return true
    }

}

