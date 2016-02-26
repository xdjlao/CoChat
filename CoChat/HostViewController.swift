import UIKit

class HostViewController: UIViewController, ChannelsVCDelegate {
    @IBOutlet var tableView: UITableView!
    
    var cellContent:[String: [String]] = [
        "basicContent":["Create A Room",
            "Name Of Room",
            "Description Of Room"],
        
        "advancedContent":["Advanced Settings",
            "Room Passcode",
            "Privacy",
            "Embed Channels"]
    ]
    
    var nameOfRoom:String?
    var descriptionOfRoom:String?
    var roomPassCode:String?
    var createChannels = false
    var privateRoom = false
    var toggleAdvancedSettings = false
    var channels = [Channel]()
    var enableSegue = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        configureTableView()
    }
    
    func setUpUI(){
        toggleAdvancedSettings = false
        let headerNib = UINib(nibName: "HostReusableCell", bundle: nil)
        tableView.registerNib(headerNib, forCellReuseIdentifier: "Host Reusable Cell")
        let addRoomButton = UIBarButtonItem(title: "Create Room", style: UIBarButtonItemStyle.Plain, target: self, action: "addRoomButtonWasTapped")
        navigationItem.rightBarButtonItem = addRoomButton
        navigationItem.rightBarButtonItem?.enabled = false
        tableView.scrollEnabled = false
    }
    
    func addRoomButtonWasTapped(){
        if !checkIfLoggedIn() {
            return
        }
        guard let name = nameOfRoom, description = descriptionOfRoom else { return }
        let entryKey = roomPassCode ?? "123"
        let user = FirebaseManager.manager.user
        let privateRoomAsInt = convertBooltoInt(privateRoom)
        
        Room.createNewRoomWith(name, subtitle: description, host: user, privateRoom: privateRoomAsInt, password: entryKey) { newRoom in
            self.performSegueWithSegueIdentifier(SegueIdentifier.SegueToMessaging, sender: newRoom)
        
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier {
        case SegueIdentifier.SegueToMessaging.rawValue?:
            guard let nvc = segue.destinationViewController as? UINavigationController, room = sender as? Room else { return }
            guard let mvc = nvc.viewControllers[0] as? MessagingViewController else { return }
            mvc.room = room
            
            room.channels = channels.map { channel -> Channel in
                return Channel(title: channel.title, subtitle: channel.subtitle, privateChannel: channel.privateChannel, password: channel.password, room: room)
            }
            
            mvc.currentChannel = room.channels[0]
            return
            
        case SegueIdentifier.SegueToChannelsVC.rawValue?:
            guard let cvc =  segue.destinationViewController as? ChannelsVC else { return }
            cvc.tempRoom = nameOfRoom!
            if channels.count > 0 {
                cvc.channels = channels
            }
            cvc.delegate = self
            return
        default: assertionFailure()
        }
    }
    
    func convertBooltoInt(bool:Bool) -> Int {
        return bool == true ? 1 : 0
    }
    
    func channelsVC(channelsVC: ChannelsVC, didCreateChannel channel: AnyObject) {
        let addChannel = channel as! Channel
        channels.append(addChannel)
    }
}


//HostReusableCellDelegate
extension HostViewController: HostReusableCellDelegate {
    func hostReusableCell(cell: HostReusableCell, valueDidChange: AnyObject?) {
        switch cell.type {
        case .NameOfRoom:
            nameOfRoom = valueDidChange as? String
            enableSegue = true
            navigationItem.rightBarButtonItem?.enabled = true
        case .DescriptionOfRoom:
            descriptionOfRoom = valueDidChange as? String
        case .PasscodeOfRoom:
            roomPassCode = valueDidChange as? String
        case .Privacy:
            if let boolValue = valueDidChange as? Bool {
                privateRoom = boolValue
            }
            print("switch was tapped inside HostVC")
        default:
            assertionFailure()
        }
    }
    
    func textFieldDidBeginEditingInCell(textField: UITextField) {
        let textFieldPosition = textField.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(textFieldPosition)
        let cell = tableView.cellForRowAtIndexPath(indexPath!)
        
        tableView.setContentOffset(CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + CGFloat(indexPath!.row) * (cell?.frame.height)! - (navigationController?.navigationBar.frame.height)!), animated: true)
    }
    
    func textFieldDidEndEditingInCell() {
        tableView.setContentOffset(CGPointMake(self.tableView.contentOffset.x, 0.0), animated: true)
    }

}


//MARK - UITableView
extension HostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView(){
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Host Reusable Cell") as! HostReusableCell
        cell.setUpCellAtIndexPath(indexPath, cellContent: cellContent)
        cell.delegate = self
        return cell
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return cellContent["basicContent"]!.count
        case 1:
            if toggleAdvancedSettings == true {
                return cellContent["advancedContent"]!.count
            } else {
                return 1
            }
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath)
        view.endEditing(true)
        let index = NSIndexSet(index: 1)
        switch (indexPath.section, indexPath.row){
        case (1,0):
            toggleAdvancedSettings = !toggleAdvancedSettings
            tableView.scrollEnabled = true
            tableView.reloadSections(index, withRowAnimation: UITableViewRowAnimation.Fade)
        case (1,3):
            if enableSegue == true {
            performSegueWithSegueIdentifier(SegueIdentifier.SegueToChannelsVC, sender: self)
            }
        default:break
        }
    }
    
}