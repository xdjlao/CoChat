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
        
        guard let indexPathOfLastCell = lastIndexPath() else { return }
        self.scrollToRowAtIndexPath(indexPathOfLastCell, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }

        func contentOffSetToLastMessage(){
            self.contentOffset = CGPointMake(0, self.contentSize.height)
        }
        
    func lastIndexPath() -> NSIndexPath? {
        let lastRowIndex = self.numberOfRowsInSection(0)
        guard lastRowIndex > 0 else { return nil }
        let indexPath = NSIndexPath(forRow: lastRowIndex - 1, inSection: 0)
        return indexPath
    }

}

