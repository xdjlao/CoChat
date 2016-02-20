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

        // Do any additional setup after loading the view.
        let tbHeight = tabBar.frame.size.height
        let frame = CGRectMake((tabBar.frame.size.width - 70)/2,0, 70, tbHeight)
        let button = UIButton(frame: frame)
        button.backgroundColor = UIColor.blackColor()
        button.addTarget(self, action: "openScan", forControlEvents: UIControlEvents.TouchUpInside)
        button.setTitle("Scan", forState: UIControlState.Normal)
        tabBar.addSubview(button)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openScan() {
        performSegueWithIdentifier("TabToScan", sender: self)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TabToScan" {
            //let destination = segue.destinationViewController as! ScanViewController
        }
    }

}
