import UIKit

class MessagingViewController: UIViewController, UITextViewDelegate, MenuChannelViewControllerDelegate {
    @IBOutlet weak var textView: UITextView! {
        didSet {
            guard let currentChannelTitle = currentChannel?.title else { return }
            textView.text = currentChannelTitle
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var channelButtonOutlet: UIButton!
    @IBOutlet weak var sendButtonOutlet: UIButton!
    
    var messages = [Message]()
    
    let manager = FirebaseManager.manager
    let ref = FirebaseManager.manager.ref
    var user: User?
    var room: Room! {
        didSet {
            navigationItem.title = room.title
        }
    }
    var currentChannel:Channel! {
        didSet {
            //      if tableView != nil {
            //         ref.removeAllObservers()
            //         currentListener = listenForNewMessagesForCurrentChannel()
            //      }
            guard let roomLabel = textView else { return }
            roomLabel.text = room.title + " - " + currentChannel.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.autocorrectionType = UITextAutocorrectionType.Yes
        uiSetup()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        user = manager.user
        Type.Message.firebase().removeAllObservers()
        messages.removeAll()
        tableView.reloadData()
        currentListener = listenForNewMessagesForCurrentChannel()
    }
    
    var currentListener: UInt?
    
    func listenForNewMessagesForCurrentChannel() -> UInt {
        return manager.listenForChildForParent(Message(), parent: currentChannel) { child in
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.messages.append(child)
                let indexPath = NSIndexPath(forRow: self.messages.count - 1, inSection: 0)
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
            })
        }
    }
    
    //MARK Actions
    @IBAction func sendButton(sender: UIButton) {
        if (textView.text != "") {
            guard let user = user else { return }
            let _ = Message(messageText: textView.text!, timeStamp: String(NSDate()), poster: user, channel: currentChannel)
            textView.text = ""
        }
    }
    
    @IBAction func onBrowseTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func menuChannelViewController(menuChannelViewController: MenuChannelViewController, didSelectChannel channel: AnyObject) {
        guard let selectedChannel = channel as? Channel else { return }
        currentChannel = selectedChannel
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.MessageToChannelSegue.rawValue {
            //let nav = segue.destinationViewController as! UINavigationController
            guard let mcvc = segue.destinationViewController as? MenuChannelViewController else { return }
            mcvc.delegate = self
            mcvc.channels = room.channels
            
        } else if segue.identifier == "ShowShare" {
            guard let svc = segue.destinationViewController as? ShareViewController else { return }
            svc.channel = currentChannel
        }
    }
}
