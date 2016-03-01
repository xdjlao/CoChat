import UIKit
import Firebase

class WhisperViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var conversations = [Conversation]()
    
    
    override func viewWillAppear(animated: Bool) {
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
}

extension WhisperViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WhisperCell", forIndexPath: indexPath) as! WhisperCell
        let conversation = conversations[indexPath.row]
        if conversation.firstUser.name == FirebaseManager.manager.user.name {
            cell.nameLabel.text = conversation.secondUser.name
        } else if conversation.secondUser.name == FirebaseManager.manager.user.name {
            cell.nameLabel.text = conversation.firstUser.name
        }
        cell.messageLabel.text = "placeholder"
        cell.profileImageView.image = UIImage(named: "dummyImage")
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let conversation = conversations[indexPath.row]
        performSegueWithSegueIdentifier(.SegueToMessaging, sender: conversation)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        guard let mvc = segue.destinationViewController as? MessagingViewController else { return }
        mvc.currentConversation = sender as! Conversation
    }
    
}