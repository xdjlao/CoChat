import UIKit

extension UITableView {
    func lastIndexPath() -> NSIndexPath? {
        let lastRowIndex = self.numberOfRowsInSection(0)
        guard lastRowIndex > 0 else { return nil }
        let indexPath = NSIndexPath(forRow: lastRowIndex - 1, inSection: 0)
        return indexPath
    }
}

