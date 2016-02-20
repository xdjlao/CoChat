import UIKit

class BrowseViewController: UIViewController {

    enum RecentOrTop: Int{
        case Recent = 0
        case Top = 1
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            setUpTableView()
        }
    }
    var recentRooms = [Room]()
    var topRooms = [Room]()
    let manager = FirebaseManager.manager
    let ref = FirebaseManager.manager.ref
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        getRecentRooms()
        getAllRooms()
    }
    
    func getAllRooms() {
        ref.childByAppendingPath("/Room").queryOrderedByChild("privateRoom").queryEqualToValue(0).observeEventType(.Value, withBlock: { snapshot in
            self.topRooms = Room.arrayFromSnapshot(snapshot) ?? [Room]()
            self.tableView.reloadData()
        })
    }
    
    func getRecentRooms() {
        manager.user.recentRoomUIDs.forEach { roomUID in
            ref.childByAppendingPath("/Room").queryOrderedByKey().queryEqualToValue(roomUID).observeSingleEventOfType(.Value, withBlock: { snapshot in
                guard let value = snapshot.value as? [NSObject: AnyObject] else { return }
                
                let keys = Array(value.keys)
                let values = Array(value.values)
                let uid = keys[0] as? String ?? "No UID"
                guard let roomInformation = values[0] as? [NSObject: AnyObject] else { return }
                
                let room = Room(fromDictionary: roomInformation, andUID: uid)
                self.recentRooms.append(room)
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let nav = segue.destinationViewController as? UINavigationController else { return }
        guard let mvc = nav.topViewController as? MessagingViewController else { return }
        guard let room = sender as? Room else { return }
        mvc.room = room
        mvc.currentChannel = room.channels[0]
    }
    
}

extension BrowseViewController: UITableViewDataSource, UITableViewDelegate {
    
    func setUpTableView() {
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if recentRooms.count == 0 {
            return 1
        } else {
            return 2
        }
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let width = tableView.frame.width
        let header = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 30))
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: width, height: 30))
        header.backgroundColor = UIColor.lightGrayColor()
        if recentRooms.count == 0 {
            label.text = "Active Rooms"
        } else {
            switch section {
            case 0: label.text = "Recent Rooms"
            case 1: label.text = "Active Rooms"
            default: label.text = "Nothing"
            }
        }
        header.addSubview(label)
        return header
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recentRooms.count == 0 {
            return topRooms.count
        } else {
            switch section {
            case 0: return recentRooms.count
            case 1: return topRooms.count
            default: assertionFailure("BrowseVC.tableView asked for more than two sections."); return 0
            }
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if recentRooms.count == 0 {
            return setUpTopRoomCell(forIndexPath: indexPath)
        } else {
            switch indexPath.section {
            case 0: return setUpRecentRoomCell(forIndexPath: indexPath)
            case 1: return setUpTopRoomCell(forIndexPath: indexPath)
            default: assertionFailure("BrowseVC.tableView asked for more than two sections."); return setUpRecentRoomCell(forIndexPath: indexPath)
            }
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var room: Room!
        if recentRooms.count == 0 {
            room = topRooms[indexPath.row]
        } else {
            switch indexPath.section {
            case 0: room = recentRooms[indexPath.row]
            case 1: room = topRooms[indexPath.row]
            default: assertionFailure("BrowseVC.tableView asked for more than two sections.")
            }
        }
        
        manager.getChildrenForParent(Channel(), parent: room) { (children) in
            guard let children = children else { return }
            room.channels = children
            self.performSegueWithSegueIdentifier(.SegueToMessaging, sender: room)
        }
    }
    func setUpRecentRoomCell(forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let room = recentRooms[indexPath.row]
        let cell = tableView.dequeueReusableCellWithCellIdentifier(.RecentRoomCell)
        cell.textLabel?.text = room.title
        return cell
    }
    func setUpTopRoomCell(forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let room = topRooms[indexPath.row]
        let cell = tableView.dequeueReusableCellWithCellIdentifier(.RecentRoomCell)
        cell.textLabel?.text = room.title
        return cell
    }
}

