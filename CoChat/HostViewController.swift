import UIKit

class HostViewController: UIViewController, ChannelsVCDelegate {
    @IBOutlet var tableView: UITableView!
    
    var nameOfRoom:String?
    var roomPassCode:String?
    var createChannels = false
    var privateRoom = 0
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
        tableView.scrollEnabled = false
        tableView.backgroundColor = Theme.Colors.BackgroundColor.color
        let addRoomButton = UIBarButtonItem(title: "Create Room", style: UIBarButtonItemStyle.Plain, target: self, action: "addRoomButtonWasTapped")
        navigationItem.rightBarButtonItem = addRoomButton
        navigationItem.rightBarButtonItem?.enabled = false
        navigationController?.navigationBar.tintColor = Theme.Colors.ButtonColor.color
    }
    
    func addRoomButtonWasTapped(){
        if FirebaseManager.manager.authData == nil {
            presentLoginScreen()
            return
        }
        guard let name = nameOfRoom else { return }
        let user = FirebaseManager.manager.user
        if let enteredPassCode = roomPassCode {
        FirebaseManager.manager.checkForUniqueEntryKey(enteredPassCode) { result in
                    if result {
                        Room.createNewRoomWith(name, host: user, privateRoom: self.privateRoom, password: enteredPassCode) { newRoom in
                            self.performSegueWithSegueIdentifier(SegueIdentifier.SegueToMessaging, sender: newRoom)
                            return
                        }
                    }
                    else{
                        self.alertNonUniquePassCode()
                    }
                }
            }
            else {
                createRandomPassCode()
                }
            }

    
    func createRandomPassCode() {
        let passCode = generateRandomPassCode()
        let user = FirebaseManager.manager.user
        FirebaseManager.manager.checkForUniqueEntryKey(passCode) { result in
            if result {
                    Room.createNewRoomWith(self.nameOfRoom!, host:user, privateRoom: self.privateRoom, password: passCode) {newRoom in
                    self.performSegueWithSegueIdentifier(SegueIdentifier.SegueToMessaging, sender: newRoom)
                return
            }
            }
            else {
                self.createRandomPassCode()
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier {
        case SegueIdentifier.SegueToMessaging.rawValue?:
            guard let nvc = segue.destinationViewController as? UINavigationController, room = sender as? Room else { return }
            guard let mvc = nvc.viewControllers[0] as? MessagingViewController else { return }
            mvc.room = room
            if channels.isEmpty {
                Channel.createNewChannelWith("Main", room: room, privateChannel: privateRoom, password: room.password, withCompletionHandler: { new in
                    room.channels.append(new)
                    mvc.currentChannel = room.channels[0]
                })
            } else {
                for channel in channels {
                    Channel.createNewChannelWith(channel.title, room: room, privateChannel: channel.privateChannel, password: channel.password, withCompletionHandler: { new in
                        room.channels.append(new)
                        mvc.currentChannel = room.channels[0]
                    })
                }
            }
            
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
            let str = nameOfRoom as String?
            if str?.characters.count > 1 {
                navigationItem.rightBarButtonItem?.enabled = true
            }
            else {
                navigationItem.rightBarButtonItem?.enabled = false
            }
        case .PasscodeOfRoom:
            roomPassCode = valueDidChange as? String
        case .Privacy:
            if let aSwitch = valueDidChange as? UISwitch {
                let privacy = aSwitch.on
                cell.enteredPrivacy = privacy
                switch convertBooltoInt(privacy) {
                case 0: privateRoom = 1
                case 1: privateRoom = 0
                default:
                    break
                }
                guard let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 3)) as? HostReusableCell else {return}
                switch privateRoom {
                case 1:
                    cell.title.text = "Private"
                default:
                    cell.title.text = "Public"
                }
            }
        default:
            assertionFailure()
        }
    }
    
    func textFieldDidBeginEditingInCell(textField: UITextField) {
        guard let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 3)) as? HostReusableCell else {return}
        let nameRoomLocation = cell.title.convertRect(cell.frame, fromCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
        let textFieldLocation = cell.convertRect(textField.frame, fromCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
        if textFieldLocation != nameRoomLocation {
            
            let textFieldPosition = textField.convertPoint(CGPointZero, toView: self.tableView)
            let indexPath = self.tableView.indexPathForRowAtPoint(textFieldPosition)
            let otherCell = tableView.cellForRowAtIndexPath(indexPath!)
            
            tableView.setContentOffset(CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + (CGFloat(indexPath!.row) * (otherCell?.frame.height)! + CGFloat(110)) - (navigationController?.navigationBar.frame.height)!), animated: true)
        }
    }
    
    func textFieldDidEndEditingInCell() {
        tableView.setContentOffset(CGPointMake(0.0, 0.0), animated: false)
        
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
        cell.resetCellUI()
        if roomPassCode != nil {
        cell.enteredPasscode = roomPassCode!}
        switch (indexPath.section, indexPath.row){
        case (0, indexPath.row):
            cell.hidden = true
        case (1, 0):
            cell.title.text = "Create a Room"
            cell.title.userInteractionEnabled = false
            cell.setHeaderUI()
            return cell
        case (2, 0):
            if nameOfRoom != nil {
             cell.title.text = nameOfRoom
             cell.title.userInteractionEnabled = true
            }
            else {
                cell.setUpCellAtIndexPath(indexPath)
                cell.delegate = self
            }
        default:
            cell.setUpCellAtIndexPath(indexPath)
            cell.delegate = self
        }
        return cell
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return 1
        case 2:
            return cellContent["basicContent"]!.count
        case 3:
            if toggleAdvancedSettings == true {
                return cellContent["advancedContent"]!.count
            } else {
                return 1
            }
        default:
            assertionFailure("this section shouldn't exist")
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        view.endEditing(true)
        let index = NSIndexSet(index: 3)
        switch (indexPath.section, indexPath.row){
        case (3,0):
            animateCellBackGround(indexPath)
            toggleAdvancedSettings = !toggleAdvancedSettings
            tableView.scrollEnabled = true
            tableView.reloadSections(index, withRowAnimation: UITableViewRowAnimation.Fade)
        case (3,3):
            animateCellBackGround(indexPath)
            if enableSegue == true {
                performSegueWithSegueIdentifier(SegueIdentifier.SegueToChannelsVC, sender: self)
            }
            else {
                if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2)) as? HostReusableCell {
                    animateCellText(cell)}
            }
        default:break
        }
    }
    
    func animateCellText(cell: HostReusableCell){
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            cell.alpha = 0.5
            cell.backgroundColor = UIColor.redColor()
            }) { (Bool) -> Void in
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    cell.backgroundColor = Theme.Colors.ForegroundColor.color
                    cell.alpha = 1.0
                    }, completion: nil)
        }
    }
    
    func animateCellBackGround(indexPath: NSIndexPath){
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            cell?.backgroundColor = Theme.Colors.BackgroundColor.color
            }) { (Bool) -> Void in
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    cell?.backgroundColor = Theme.Colors.ForegroundColor.color
                    }, completion: nil)
        }
    }
}