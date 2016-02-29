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
        tabBar.barTintColor = Theme.Colors.NavigationBarColor.color
        tabBar.translucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
