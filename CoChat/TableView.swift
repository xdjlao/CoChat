//
//  TableView.swift
//  CoChat
//
//  Created by Aaron B on 2/23/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

extension UITableView {
    func scrollToLastMessage(animated: Bool = true) {
        
        let indexPathOfLastCell = lastIndexPath()
        self.scrollToRowAtIndexPath(indexPathOfLastCell, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }

        func contentOffSetToLastMessage(){
            self.contentOffset = CGPointMake(0, self.contentSize.height)
        }
        
    func lastIndexPath() -> NSIndexPath {
        let lastRowIndex = max(0, self.numberOfRowsInSection(0))
        let indexPath = NSIndexPath(forRow: lastRowIndex - 1, inSection: 0)
        return indexPath
    }

}

