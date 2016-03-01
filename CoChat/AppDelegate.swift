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
        
        window?.tintColor = Theme.Colors.BackgroundColor.color
        let navBarAppearance = UINavigationBar.appearance()
        let navBarButtonAppearance = UIBarButtonItem.appearance()
        let tabBarAppearance = UITabBar.appearance()
        
        navBarAppearance.titleTextAttributes = [
            NSFontAttributeName: Theme.Fonts.BoldTitleTypeFace.font,
            NSForegroundColorAttributeName: Theme.Colors.ButtonColor.color]
        
        navBarAppearance.barStyle = UIBarStyle.Black
        navBarAppearance.barTintColor = Theme.Colors.NavigationBarColor.color
        //set custom logo here
        navBarButtonAppearance.tintColor = Theme.Colors.ButtonColor.color
        
        tabBarAppearance.tintColor = Theme.Colors.ButtonColor.color
        tabBarAppearance.backgroundColor = Theme.Colors.NavigationBarColor.color
        
        
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
      FirebaseManager.manager.ref.observeAuthEventWithBlock { (authData: FAuthData?) in
         print(authData)
            if let authData = authData {
                FirebaseManager.manager.handleUserAuthData(authData, withMainQueueCompletionHandler: nil)
            }
        }
        return true
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        guard let host = url.host else { return false }
        guard let roomID = url.pathComponents else { return false }
        if host == "room" && !roomID.isEmpty {
            FirebaseManager.manager.checkForRoomWithEntryKey(roomID[1], completionHandler: { (room) -> () in
                
                let messageStoryboardNavigation = UIStoryboard(name: "Main", bundle: nil)
                let mainTab = messageStoryboardNavigation.instantiateViewControllerWithIdentifier("MainTabBarViewController") as? MainTabBarViewController

                self.window!.rootViewController = mainTab
                
                let rootVC = self.window!.rootViewController as! MainTabBarViewController

                rootVC.selectedIndex = 0
                
                let browseNav = rootVC.viewControllers![0] as! BrowseNavigationViewController
                let browseVC = browseNav.topViewController as! BrowseViewController
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    browseVC.performSegueWithSegueIdentifier(.SegueToMessaging, sender: room)
                })
                
            })
            return true
        } else {
            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        }
    }
    
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
}