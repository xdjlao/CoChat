//
//  DismissSegue.swift
//  CoChat
//
//  Created by Jerry on 2/24/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

class DismissSegue: UIStoryboardSegue {

    override func perform() {
//        let sourceVC = sourceViewController as! MessagingViewController
//        let destinationVC = destinationViewController as! UITabBarController
//        destinationVC.selectedIndex = 1
//        sourceVC.dismissViewControllerAnimated(true) { () -> Void in
//            destinationVC.presentingViewController
//        }
        let sourceVC = sourceViewController as! MessagingViewController
        if let destinationVC = destinationViewController as? UITabBarController {
            sourceVC.dismissViewControllerAnimated(true, completion: { () -> Void in
                destinationVC.presentingViewController
            })
        } else {
            
        }
    }
    
}
