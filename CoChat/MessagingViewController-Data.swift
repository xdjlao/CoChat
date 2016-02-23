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
      guard let roomLabel = textView else { return }
      roomLabel.text = room.title + " - " + currentChannel.title
      }
   }
   
   func addRoomToRecent() {
      guard !user?.recentRooms.contains ({ (room: Room) -> Bool in
         return room === self.room
      }) else { return }
      user?.recentRoomUIDs.append(room.uid)
      user?.recentRooms.append(room)
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
            self.messages.sortInPlace { first, second in
               let formatter = NSDateFormatter()
               print(first.time)
               print(second.time)
               print("attempting to get date from string")
            
               return first.time.compare(second.time) == NSComparisonResult.OrderedAscending
            }
         })
      }
   }
   
   //MARK Actions
   @IBAction func sendButton(sender: UIButton) {
      if (textView.text != "") {
         guard let user = user else { return }
         let formatter = NSDateFormatter()
         
         formatter.dateStyle = .ShortStyle
         formatter.timeStyle = .ShortStyle
         let _ = Message(messageText: textView.text!, timeObject: FirebaseServerValue.timestamp(), poster: user, channel: currentChannel)
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
        svc.room = room
      }
   }
}
