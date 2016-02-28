//
//  UIColor+Extension.swift
//  CoChat
//
//  Created by Aaron B on 2/27/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        let red = r/255.0
        let green = g/255.0
        let blue = b/255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
