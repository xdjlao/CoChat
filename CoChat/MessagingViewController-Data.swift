import UIKit
import Firebase

class MessagingViewController: UIViewController, UITextViewDelegate, MenuChannelViewControllerDelegate {
   @IBOutlet weak var textView: UITextView! {
      didSet {
      guard let currentChannelTitle = currentChannel?.title else { return }
      textView.text = currentChannelTitle
      textView.autocorrectionType = UITextAutocorrectionType.Yes
      }
   }
   @IBOutlet weak var tableView: UITableView! {
      didSet {
      tableView.delegate = self
      tableView.dataSource = self
      }
   }
   override func viewDidLoad() {
      super.viewDidLoad()
      uiSetup()
   }
   @IBOutlet var buttonContainer: UIView!
   @IBOutlet weak var channelButtonOutlet: UIButton!
   @IBOutlet weak var sendButtonOutlet: UIButton!
   
   var messageFirebase: FirebaseArray<Message>!
   
   func setUpMessageFirebase() {
      let firebaseArray = FirebaseArray<Message>()
      firebaseArray.sortFunction = { first, second in
         return first.time.compare(second.time) == NSComparisonResult.OrderedAscending
      }
      firebaseArray.ref = FirebaseManager.manager.ref.childByAppendingPath("Message")
      firebaseArray.queryOrderedByChild = "channelUID"
      firebaseArray.queryEqualToValue = self.currentChannel.uid
      firebaseArray.eventType = .ChildAdded
      firebaseArray.queryLimitedToLast = 10
      firebaseArray.completionHandlerForChildAdded = {
         let indexPath = NSIndexPath(forRow: firebaseArray.items.count - 1, inSection: 0)
         self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .None)
         self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
      }
      messageFirebase = firebaseArray
   }
   var room: Room! {
      didSet {
      navigationItem.title = room.title
      }
   }
   var currentChannel:Channel! {
      didSet {
      setUpMessageFirebase()
      messageFirebase.startListenerForAll()
      guard let roomLabel = textView else { return }
      roomLabel.text = room.title + " - " + currentChannel.title
      }
   }
   
   let manager = FirebaseManager.manager
   let ref = FirebaseManager.manager.ref
   
   func addRoomToRecent() {
      guard !(FirebaseManager.manager.user.recentRooms.contains ({ (room: Room) -> Bool in
         return room === self.room
      })) else { return }
      FirebaseManager.manager.user.recentRoomUIDs.append(room.uid)
      FirebaseManager.manager.user.recentRooms.append(room)
   }
   
   
   var startUID: String!
   var endUID: String!
   var increment: UInt = 10
   
   //MARK Actions
   @IBAction func sendButton(sender: UIButton) {
      if FirebaseManager.manager.authData == nil {
         presentLoginScreen()
         return
      }
      if (textView.text != "") {
         Message.createNewMessageWith(textView.text, timeObject: FirebaseServerValue.timestamp(), poster: FirebaseManager.manager.user, channel: currentChannel, withCompletionHandler: nil)
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
