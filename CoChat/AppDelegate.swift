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
//        FirebaseManager.manager.ref.observeAuthEventWithBlock { authData in
//            if let authData = authData {
//                FirebaseManager.manager.handleUserAuthData(authData, withMainQueueCompletionHandler: nil)
//            }
//         print("facebook ref observeAuthEventWithBlock")
//        }
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
        if url.host == "room" {
            let messageStoryboard = UIStoryboard(name: "Host", bundle: nil)
            let rootViewController = messageStoryboard.instantiateViewControllerWithIdentifier("HostViewController") as? HostViewController
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            self.window!.rootViewController = rootViewController
            
            self.window!.makeKeyAndVisible()
        }
        return true
    }

}

