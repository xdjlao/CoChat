import UIKit

class HostViewController: UIViewController {
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
            mvc.currentChannel = room.channels[0]
            return
            
        case SegueIdentifier.PushToChannelsVC.rawValue?:
            guard let cvc =  UIViewController() as? ChannelsVC else { return }
            cvc.room = nameOfRoom
            return
        default: break
        }
    }
    
    func convertBooltoInt(bool:Bool) -> Int {
        if bool == true {
            return 1
        }
        else {
            return 0
        }
    }
}

//HostReusableCellDelegate
extension HostViewController: HostReusableCellDelegate {
    func hostReusableCell(cell: HostReusableCell, valueDidChange: AnyObject?) {
        switch cell.type {
        case .NameOfRoom:
            nameOfRoom = valueDidChange as? String
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
        let index = NSIndexSet(index: 1)
        switch (indexPath.section, indexPath.row){
        case (1,0):
            toggleAdvancedSettings = !toggleAdvancedSettings
            tableView.scrollEnabled = true
            tableView.reloadSections(index, withRowAnimation: UITableViewRowAnimation.Fade)
        case (1,3):
            performSegueWithIdentifier("PushChannelsVC", sender: self)
        default:break
        }
    }
    
}


