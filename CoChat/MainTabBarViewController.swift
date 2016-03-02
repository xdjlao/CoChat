//
//  MainTabBarViewController.swift
//  CoChat
//
//  Created by Jerry on 2/19/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarUI()
    }
    
    func setupTabBarUI(){
        let tabBar = self.tabBar
        guard let tabBarItem1 = tabBar.items?[0] else {return print("couldn't locate TB1image")}
        guard let tabBarItem2 = tabBar.items?[1] else {return print("couldn't locate TB2image")}
        guard let tabBarItem3 = tabBar.items?[2] else {return print("couldn't locate TB3image")}
        guard let tabBarItem4 = tabBar.items?[3] else {return print("couldn't locate TB4image")}
        
        tabBarItem1.title = "Blend"
        tabBarItem2.title = "Whisper"
        tabBarItem3.title = "Join"
        tabBarItem4.title = "Profile"
        
        tabBarItem1.image = UIImage(named: "blendTabBar")
        tabBarItem2.image = UIImage(named: "whisper")
        tabBarItem3.image = UIImage(named: "join")
        tabBarItem4.image = UIImage(named: "profile")
        tabBar.barTintColor = Theme.Colors.NavigationBarColor.color
        tabBar.translucent = false
        tabBar.setValue(true, forKey: "_hidesShadow")
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        //let sourceViewController = segue.sourceViewController
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        if segue.identifier == "TabToScan" {
    //            //let destination = segue.destinationViewController as! ScanViewController
    //        }
    //    }
    
}
