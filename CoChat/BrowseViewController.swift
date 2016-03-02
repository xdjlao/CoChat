import UIKit

class BrowseViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            //setUpTableView()
        }
    }
    
    var rooms = [Room]()
    let manager = FirebaseManager.manager
    let ref = FirebaseManager.manager.ref
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getAllRooms()
    }
    
    func setUpUI(){
        tableView.rowHeight = 71
        tableView.separatorColor = UIColor.clearColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = Theme.Colors.BackgroundColor.color
    }
    
    func getAllRooms() {
        self.rooms.removeAll()
        ref.childByAppendingPath("/Room").queryOrderedByChild("privateRoom").queryEqualToValue(0).observeEventType(.Value, withBlock: { snapshot in
            self.rooms = Room.arrayFromSnapshot(snapshot) ?? [Room]()
            self.tableView.reloadData()
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        ref.childByAppendingPath("Room").removeAllObservers()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let nav = segue.destinationViewController as? MessagingNavigationViewController else { return }
        guard let mvc = nav.topViewController as? MessagingViewController else { return }
        guard let room = sender as? Room else { return }
        mvc.room = room
        mvc.currentChannel = room.channels[0]
    }
}

extension BrowseViewController: UITableViewDataSource, UITableViewDelegate {
    
    //    func setUpTableView() {
    //    }
    //    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    //        if recentRooms.count == 0 {
    //            return 1
    //        } else {
    //            return 2
    //        }
    //    }
    //    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let width = tableView.frame.width
    //        let header = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 30))
    //        let label = UILabel(frame: CGRect(x: 10, y: 0, width: width, height: 30))
    //        header.backgroundColor = UIColor.lightGrayColor()
    //        if recentRooms.count == 0 {
    //            label.text = "Active Rooms"
    //        } else {
    //            switch section {    //            case 0: label.text = "Recent Rooms"
    //            case 1: label.text = "Active Rooms"
    //            default: label.text = "Nothing"
    //            }
    //        }
    //        header.addSubview(label)
    //        return header
    //    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return setUpRoomCell(forIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let room = self.rooms[indexPath.row]
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? TopRoomCell else {return}
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: [], animations: { () -> Void in
            cell.cellWrapperView.backgroundColor = Theme.Colors.BackgroundColor.color
            }) { (Bool) -> Void in
                cell.cellWrapperView.backgroundColor = Theme.Colors.ForegroundColor.color
                self.manager.getChildrenForParent(Channel(), parent: room) { (children) in
                    guard let children = children else { return }
                    room.channels = children
                    self.performSegueWithSegueIdentifier(.SegueToMessaging, sender: room)
                }
        }
    }
    
    func setUpRoomCell(forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let room = rooms[indexPath.row]
        let cell = tableView.dequeueReusableCellWithCellIdentifier(.TopRoomCell) as! TopRoomCell
        cell.countLabel.text = "\(indexPath.row + 1)"
        cell.roomTitleLabel.text = room.title
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.countLabel.textColor = Theme.Colors.DarkButtonColor.color
        if indexPath.row == rooms.count - 1 {
            cell.cellSeperator.backgroundColor = Theme.Colors.BackgroundColor.color
            cell.countCellSeperator.backgroundColor = Theme.Colors.BackgroundColor.color
        }
        return cell
    }
}



