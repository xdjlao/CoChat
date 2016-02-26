import UIKit
import Firebase

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
//   @IBOutlet weak var buttonToTableViewConstraint: NSLayoutConstraint!
//   @IBOutlet weak var buttonsContainer: UIView!
    
   var messages = [Message]() {
      didSet {
      messages.sortInPlace { first, second in
         return first.time.compare(second.time) == NSComparisonResult.OrderedAscending
      }
      }
   }
   
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
      guard let roomLabel = textView else { return }
      roomLabel.text = room.title + " - " + currentChannel.title
      }
    
    
   }
   
   func addRoomToRecent() {
      guard let user = user else { return }
      guard !(user.recentRooms.contains ({ (room: Room) -> Bool in
         return room === self.room
      })) else { return }
      user.recentRoomUIDs.append(room.uid)
      user.recentRooms.append(room)
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
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
         })
      }
   }
   
   var startUID: String!
   var endUID: String!
   var increment: UInt = 10
   
   //MARK Actions
   @IBAction func sendButton(sender: UIButton) {
      if (textView.text != "") {
         guard let user = user else { return }
         Message.createNewMessageWith(textView.text, timeObject: FirebaseServerValue.timestamp(), poster: user, channel: currentChannel, withCompletionHandler: nil)
         textView.text = ""
        self.tableView.scrollToLastMessage(false)
      }
   }
   
//   @IBAction func onBrowseTapped(sender: UIBarButtonItem) {
//      performSegueWithIdentifier("", sender: nil)
//   }
   
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
