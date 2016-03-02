import UIKit
import Firebase


class MessagingViewController: UIViewController, UITextViewDelegate, MenuChannelViewControllerDelegate {
   
    @IBOutlet var buttonContainer: UIView!
    @IBOutlet weak var channelButtonOutlet: UIButton!
    @IBOutlet weak var sendButtonOutlet: UIButton!
    var topSection:CGFloat?
    var firstType = true

    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.autocorrectionType = UITextAutocorrectionType.Yes
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = Theme.Colors.ForegroundColor.color
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "getMoreMessages:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        tableView.sendSubviewToBack(refreshControl)
        
        uiSetup()
    }
    
    override func viewDidAppear(animated: Bool) {
        scrollToBottomMessage()
    }
    
    func scrollToBottomMessage(keyboardHeight:CGFloat = 0) {
        if tableView.contentSize.height > tableView.frame.height {
            tableView.setContentOffset(CGPointMake(0, tableView.contentSize.height - tableView.frame.height - keyboardHeight), animated: false)
        }
    }
    
    var oldestMessage: Message?
    
    func getMoreMessages(refreshControl: UIRefreshControl) {
        guard let oldestMessage = oldestMessage else {
            refreshControl.endRefreshing()

            return
        }
        let ref = mode.firebase(forUID: currentUID)
        ref.queryLimitedToLast(10).queryStartingAtValue(oldestMessage.uid).observeSingleEventOfType(.Value, withBlock: { snapshot in
            guard let messages = Message.arrayFromSnapshot(snapshot, withCreatorUID: self.currentUID) else { return }
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                for message in messages {
                    self.messages.append(message)
                    self.sortMessages()
                    self.oldestMessageCheck(message)
                    let indexPath = NSIndexPath(forRow: self.messages.count - 1, inSection: 0)
                    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
                refreshControl.endRefreshing()
            }
        })
    }
    

    enum Mode {
        case Chat
        case Whisper
        
        func firebase(forUID uid: String) -> Firebase {
            switch self {
            case .Chat:
                return FirebaseManager.manager.ref.childByAppendingPath("Channel").childByAppendingPath(uid).childByAppendingPath("Messages")
            case .Whisper:
                return FirebaseManager.manager.ref.childByAppendingPath("Conversation").childByAppendingPath(uid).childByAppendingPath("Whispers")
            }
        }
    }
    var mode: Mode {
        if currentChannel == nil && currentConversation != nil {
            return .Whisper
        } else if currentChannel != nil && currentConversation == nil {
            return .Chat
        } else {
            assertionFailure()
            return .Whisper
        }
    }
    var currentUID: String {
        if currentChannel == nil && currentConversation != nil {
            return currentConversation!.uid
        } else if currentChannel != nil && currentConversation == nil {
            return currentChannel!.uid
        } else {
            assertionFailure()
            return "none"
        }
    }
    var messages = [Message]()
    
    func sortMessages() {
        messages.sortInPlace { first, second in
            return first.time.compare(second.time) == NSComparisonResult.OrderedAscending
        }
    }
    
    func oldestMessageCheck(toCompare: Message) {
        if oldestMessage == nil || oldestMessage?.time.compare(toCompare.time) == .OrderedDescending {
            oldestMessage = toCompare
        }
    }
    
    func setUpListener() {
        let ref = mode.firebase(forUID: currentUID)
        ref.queryLimitedToFirst(11).observeEventType(.ChildAdded, withBlock: { snapshot in
            guard let message = Message.singleFromSnapshot(snapshot, withCreatorUID: self.currentUID) else { return }
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.messages.append(message)
                self.sortMessages()
                self.oldestMessageCheck(message)
                let indexPath = NSIndexPath(forRow: self.messages.count - 1, inSection: 0)
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        })
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        FirebaseManager.manager.ref.removeAllObservers()
    }
    

    var room: Room! {
        didSet {
            navigationItem.title = room.title
        }
    }
    var currentChannel:Channel? {
        didSet {
            setUpListener()
            guard let roomLabel = textView else { return }
            roomLabel.text = room.title + " - " + currentChannel!.title
        }
    }
    var currentConversation: Conversation? {
        didSet {
            setUpListener()
            guard let label = textView else { return }
            label.text = currentConversation?.secondUser.name
        }
    }
    
    func addRoomToRecent() {
        guard !(FirebaseManager.manager.user.recentRooms.contains ({ (room: Room) -> Bool in
            return room === self.room
        })) else { return }
        FirebaseManager.manager.user.recentRoomsUIDs.append(room.uid)
        FirebaseManager.manager.user.recentRooms.append(room)
    }
    
    //MARK Actions
    @IBAction func sendButton(sender: UIButton) {
        if FirebaseManager.manager.authData == nil {
            presentLoginScreen()
            return
        }
        if (textView.text != "") {
            switch mode {
            case .Whisper:
                Message.createNewWhisperWith(textView.text, timeObject: FirebaseServerValue.timestamp(), poster: FirebaseManager.manager.user, conversation: currentConversation!, withCompletionHandler: nil)
            case .Chat:
            Message.createNewMessageWith(textView.text, timeObject: FirebaseServerValue.timestamp(), poster: FirebaseManager.manager.user, channel: currentChannel, withCompletionHandler: nil)
            }
            textView.text = ""
        }
    }
    
    func menuChannelViewController(menuChannelViewController: MenuChannelViewController, didSelectChannel channel: AnyObject) {
        guard let selectedChannel = channel as? Channel else { return }
        currentChannel = selectedChannel
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == SegueIdentifier.SegueToMenuChannelsVC.rawValue {
            //let nav = segue.destinationViewController as! UINavigationController
            guard let mcvc = segue.destinationViewController as? MenuChannelViewController else { return }
            mcvc.delegate = self
            mcvc.room = room
            mcvc.channels = room.channels
            
        } else if segue.identifier == SegueIdentifier.SegueToShare.rawValue {
            guard let svc = segue.destinationViewController as? ShareViewController else { return }
            svc.channel = currentChannel
            svc.room = room
        }
    }
}
