import UIKit

extension UIViewController {
    enum SegueIdentifier: String {
        case SegueToMain = "SegueToMain"
        case SegueToMessaging = "SegueToMessaging"
        case MessageToChannelSegue = "MessageToChannelSegue"
        case JoinToMessagesSegue = "JoinToMessagesSegue"
    }
    
    func performSegueWithSegueIdentifier(segueIdentifier: SegueIdentifier, sender: AnyObject?) {
        performSegueWithIdentifier(segueIdentifier.rawValue, sender: sender)
    }
    
    func shouldPerformSegueWithSegueIdentifier(segueIdentifier: SegueIdentifier, sender: AnyObject?) {
        shouldPerformSegueWithIdentifier(segueIdentifier.rawValue, sender: sender)
    }
}

extension UITableView {
    enum CellIdentifier: String {
        case Cell = "Cell"
        case RecentRoomCell = "RecentRoomCell"
        case TopRoomCell = "TopRoomCell"
        case ProfileCell = "ProfileCell"
    }
    
    func dequeueReusableCellWithCellIdentifier(cellIdentifier: CellIdentifier) -> UITableViewCell {
        return dequeueReusableCellWithIdentifier(cellIdentifier.rawValue)!
    }
}