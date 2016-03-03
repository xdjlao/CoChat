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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        conversations.removeAll()
        tableView.reloadData()
        let whisperRef = FirebaseManager.manager.ref.childByAppendingPath("Conversation")
        let userUID = FirebaseManager.manager.user.uid
        func addToConversations(snapshot: FDataSnapshot) {
            NSOperationQueue.mainQueue().addOperationWithBlock {
                guard let conversation = Conversation.singleFromSnapshot(snapshot) else { return }
                self.conversations.append(conversation)
                self.tableView.reloadData()
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
//        if conversations.count == 0 {
//            noWhispersCell(cell)
//            return cell
//        }

        let conversation = conversations[indexPath.row]
        let otherUser = getOtherUser(conversation.firstUser, secondUser: conversation.secondUser)
                cell.messageLabel.text = "Latest message"
        cell.nameLabel.text = otherUser.name
        cell.profileImageView.setImageWithURL(NSURL(string: otherUser.profileImageURL)!, placeholderImage: UIImage(named: "profileImageDummy"))
        if indexPath.row != conversations.count - 1 {
            cell.contentSeparatorView.backgroundColor = Theme.Colors.ForegroundColor.color
            cell.imageSeparatorView.backgroundColor = Theme.Colors.DarkBackgroundColor.color
        } else {
            cell.contentSeparatorView.backgroundColor = Theme.Colors.BackgroundColor.color
            cell.imageSeparatorView.backgroundColor = Theme.Colors.BackgroundColor.color
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func noWhispersCell(cell:WhisperCell){
        cell.messageLabel.hidden = true
        cell.textLabel?.text = "You don't have any Whispers!"
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.profileImageView.hidden = true
        cell.nameLabel.hidden = true
        cell.timestampLabel.hidden = true
        cell.backgroundColor = Theme.Colors.ForegroundColor.color
        cell.contentSeparatorView.hidden = true
        cell.contentWrapperView.hidden = true
        cell.imageSeparatorView.hidden = true
        cell.container.hidden = true
        cell.backgroundColor = Theme.Colors.ForegroundColor.color
    }
    
    func getOtherUser(firstUser: User, secondUser: User) -> User {
        if firstUser.uid == FirebaseManager.manager.user.uid {
            return secondUser
        } else {
            return firstUser
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if conversations.count == 0 {
//            return 1
//        }
        return conversations.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? WhisperCell else {return}
        UIView.animateWithDuration(0.2, delay: 0.0, options: [], animations: { () -> Void in
            cell.contentWrapperView.backgroundColor = Theme.Colors.BackgroundColor.color
            }) { (Bool) -> Void in
                cell.contentWrapperView.backgroundColor = Theme.Colors.ForegroundColor.color
                let conversation = self.conversations[indexPath.row]
                self.performSegueWithSegueIdentifier(.SegueToMessaging, sender: conversation)
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let nvc = segue.destinationViewController as? MessagingNavigationViewController else { return }
        guard let mvc = nvc.topViewController as? MessagingViewController else { return }
        mvc.currentConversation = sender as? Conversation
    }
    
}