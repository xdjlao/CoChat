//
//  TableView.swift
//  CoChat
//
//  Created by Aaron B on 2/23/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let row = self.numberOfRowsInSection(0)
        if row > 0 {
            self.scrollToRowAtIndexPath(NSIndexPath(forRow: row - 1, inSection:0), atScrollPosition: .Bottom, animated: animated)
        }
    }
}

