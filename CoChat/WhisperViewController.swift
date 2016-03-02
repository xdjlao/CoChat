import UIKit
import Firebase

class WhisperViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    var conversations = [Conversation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = Theme.Colors.BackgroundColor.color
        tableView.rowHeight = 71
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func viewWillAppear(animated: Bool) {
        conversations.removeAll()
        tableView.reloadData()
        let whisperRef = FirebaseManager.manager.ref.childByAppendingPath("Conversation")
        let userUID = FirebaseManager.manager.user.uid
        func addToConversations(snapshot: FDataSnapshot) {
            NSOperationQueue.mainQueue().addOperationWithBlock {
                guard let conversation = Conversation.singleFromSnapshot(snapshot) else { return }
                self.conversations.append(conversation)
                let indexPath = NSIndexPath(forRow: self.conversations.count - 1, inSection: 0)
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
        whisperRef.queryOrderedByChild("firstUID").queryEqualToValue(userUID).observeEventType(.ChildAdded, withBlock: { snapshot in
            addToConversations(snapshot)
        })
        whisperRef.queryOrderedByChild("secondUID").queryEqualToValue(userUID).observeEventType(.ChildAdded, withBlock: { snapshot in
            addToConversations(snapshot)
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
            FirebaseManager.manager.ref.childByAppendingPath("Conversation").queryOrderedByChild("firstUID").removeAllObservers()
        FirebaseManager.manager.ref.childByAppendingPath("Conversation").queryOrderedByChild("secondUID").removeAllObservers()
    }
}

extension WhisperViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WhisperCell", forIndexPath: indexPath) as! WhisperCell
        let conversation = conversations[indexPath.row]
        let otherUser = getOtherUser(conversation.firstUser, secondUser: conversation.secondUser)
        cell.messageLabel.text = "Latest message"
        cell.nameLabel.text = otherUser.name
        cell.profileImageView.setImageWithURL(NSURL(string: otherUser.profileImageURL)!, placeholderImage: UIImage(named: "profileImageDummy"))
        return cell
    }
    
    func getOtherUser(firstUser: User, secondUser: User) -> User {
        if firstUser.uid == FirebaseManager.manager.user.uid {
            return secondUser
        } else {
            return firstUser
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let conversation = conversations[indexPath.row]
        performSegueWithSegueIdentifier(.SegueToMessaging, sender: conversation)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let nvc = segue.destinationViewController as? MessagingNavigationViewController else { return }
        guard let mvc = nvc.topViewController as? MessagingViewController else { return }
        mvc.currentConversation = sender as? Conversation
    }
    
}