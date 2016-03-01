import UIKit
import AFNetworking

extension MessagingViewController: UITableViewDelegate, UITableViewDataSource, GeneralMessageCellDelegate {
   
   func animatetextViewWithKeyboard(notification: NSNotification) {
      // change the view's height to accept the size of the keyboard
      let userInfo = notification.userInfo!
      
      let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
      let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
      let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! UInt
      
      if notification.name == UIKeyboardWillShowNotification {
         self.view.frame.origin.y = -keyboardSize.height  // move up
      }
      else {
         self.view.frame.origin.y = 0 // move down
      }
      
      view.setNeedsUpdateConstraints()
      
      let options = UIViewAnimationOptions(rawValue: curve << 16)
      UIView.animateWithDuration(duration, delay: 0, options: options,
                                                     animations: {
                                                      self.view.layoutIfNeeded()
                                                      
         },
                                                     completion: nil
      )
   }
   
   func textViewDidBeginEditing(textView: UITextView) {
      if FirebaseManager.manager.authData == nil {
         presentLoginScreen()
         return
      }
      UIView.animateWithDuration(0.2, delay: 0.0, options: [], animations: { () -> Void in
         self.textView.text = "" // Clear title
         self.sendButtonOutlet.hidden = false
         self.channelButtonOutlet.hidden = true
         }, completion: nil)
   }
   
   func textViewDidEndEditing(textView: UITextView) {
      UIView.animateWithDuration(0.2, delay: 0.0, options: [], animations: { () -> Void in
         if let curChan = self.currentChannel {
            textView.text = "\(curChan.title)" // Room title
         } else {
            textView.text = "General Discussion"
         }
         self.sendButtonOutlet.hidden = true
         self.channelButtonOutlet.hidden = false
         }, completion: nil)
      
      
   }
   
   
   
   // MARK - Nib Methods
   func registerNibs(){
      let message = UINib(nibName:"GeneralMessageCell", bundle: nil)
      tableView.registerNib(message, forCellReuseIdentifier: "GeneralMessageCell")
      let userMessage = UINib(nibName: "UserMessageCell", bundle: nil)
      tableView.registerNib(userMessage, forCellReuseIdentifier: "UserMessageCell")
   }
   
   //in
   // MARK - Listeners
   func textViewBeganEditing(){
      //Flash red if over 140 count
      if (self.textView.text?.characters.count > 140){
         UIView.animateKeyframesWithDuration(0.2, delay: 0.0, options: [], animations: { () -> Void in
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1/4, animations: { () -> Void in
               self.textView.backgroundColor = UIColor.redColor()
               self.textView.alpha = 0.5
               self.textView.deleteBackward()
            })
            UIView.addKeyframeWithRelativeStartTime(1/4, relativeDuration: 1/4, animations: { () -> Void in
               self.textView.backgroundColor = UIColor.whiteColor()
            })
            UIView.addKeyframeWithRelativeStartTime(2/4, relativeDuration: 1/4, animations: { () -> Void in
               self.textView.backgroundColor = UIColor.redColor()
            })
            UIView.addKeyframeWithRelativeStartTime(3/4, relativeDuration: 1/4, animations: { () -> Void in
               self.textView.backgroundColor = UIColor.whiteColor()
               self.textView.alpha = 1.0
            })
            }, completion: nil)
      }
   }
   
   func textViewDidChange(textView: UITextView) {
      UIView.animateWithDuration(0.1, animations: { () -> Void in
         let height = self.textView.sizeThatFits(CGSizeMake(self.textView.frame.size.width, CGFloat.max)).height
         self.textView.frame.size.height = height
         self.buttonContainer.frame.size.height = textView.frame.size.height
      }) { (Bool) -> Void in
         if self.messages.count > 0 {
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.messages.count - 1, inSection: 0), atScrollPosition: .Bottom, animated: true)
         }
      }
      
   }
   
   //MARK - TableView Delegate Methods
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let currentMessage = messages[indexPath.row]
      if currentMessage.poster.name == FirebaseManager.manager.user.name {
         let cell = tableView.dequeueReusableCellWithIdentifier("UserMessageCell") as! UserMessageCell
         cell.tag = indexPath.row
         cell.messageLabel.text = currentMessage.messageText
         cell.profileImageView.setImageWithURL(NSURL(string: FirebaseManager.manager.user.profileImageURL)!, placeholderImage: UIImage(named: "profileImageDummy"))
         cell.selectionStyle = UITableViewCellSelectionStyle.None
         cell.user = FirebaseManager.manager.user
         return cell
      } else {
         let cell = tableView.dequeueReusableCellWithIdentifier("GeneralMessageCell") as! GeneralMessageCell
         cell.tag = indexPath.row
         cell.messageLabel.text = currentMessage.messageText
         cell.profileImageView.setImageWithURL(NSURL(string: currentMessage.poster.profileImageURL)!, placeholderImage:UIImage(named: "profileImageDummy"))
         cell.selectionStyle = UITableViewCellSelectionStyle.None
         cell.delegate = self
         cell.user = currentMessage.poster
         return cell
      }
   }
   
   func generalMessageCellWillDisplay(generalCell: GeneralMessageCell, indexPath: NSIndexPath) {
      generalCell.profileImageView.alpha = 0.0
      generalCell.messageLabel.alpha = 0.0
      UIView.animateWithDuration(1.2, delay: 0.0, options: [.CurveEaseInOut], animations: { () -> Void in
         generalCell.profileImageView.alpha = 1.0
         generalCell.messageLabel.alpha = 1.0
         }, completion: { bool in
      })
   }
   
   func userMessageCellWillDisplay(userCell: UserMessageCell, indexPath: NSIndexPath) {
      userCell.profileImageView.alpha = 0.0
      userCell.messageLabel.alpha = 0.0
      UIView.animateWithDuration(1.0, delay: 0.0, options:[.CurveEaseInOut], animations: { () -> Void in
         userCell.profileImageView.alpha = 1.0
         userCell.messageLabel.alpha = 1.0
         }, completion: { bool in
            
            //            self.tableView.scrollToLastMessage(true)
      })
   }
   
   
   func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
      if indexPath.row == messages.count - 1 {
         if let generalCell = cell as? GeneralMessageCell {
            generalMessageCellWillDisplay(generalCell, indexPath: indexPath)
         }
         
         if let userCell = cell as? UserMessageCell {
            userMessageCellWillDisplay(userCell, indexPath: indexPath)
         }
      }
   }
   
   func generalMessageCell(generalMessageCell: GeneralMessageCell, didTapUser user: AnyObject) {
      let currentUser = user as! User
      showUserProfile(currentUser)
   }
   
   func showUserProfile(user:User) {
      let alertController = UIAlertController(title: user.name, message: "", preferredStyle: UIAlertControllerStyle.Alert)
      let reportAction = UIAlertAction(title: "Report", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
         //
      }
      let messageAction = UIAlertAction(title: "Message", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
         //
      }
      alertController.addAction(messageAction)
      alertController.addAction(reportAction)
      presentViewController(alertController, animated: true, completion: nil)
   }
   
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return messages.count ?? 0
   }
   
   func tableViewOrientation(){
      //removes lines
      tableView.separatorStyle = .None
      //removes autocorrectbar
      textView.autocorrectionType = UITextAutocorrectionType.No
      //cells are dynamic
      tableView.estimatedRowHeight = 60.00
      tableView.rowHeight = UITableViewAutomaticDimension
   }   
   
   
   func uiSetup() {
      textView.delegate = self
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "textViewBeganEditing", name: UITextViewTextDidChangeNotification, object: nil)
      textView.scrollEnabled = false
      registerNibs()
      view.backgroundColor = Theme.Colors.BackgroundColor.color
      sendButtonOutlet.backgroundColor = Theme.Colors.ButtonColor.color
      sendButtonOutlet.tintColor = UIColor.whiteColor()
      channelButtonOutlet.backgroundColor = Theme.Colors.ButtonColor.color
      channelButtonOutlet.tintColor = UIColor.whiteColor()
      buttonContainer.backgroundColor = Theme.Colors.ButtonColor.color
      tableViewOrientation()
   }
   
   @IBAction func onBackgroundTapped(sender: UITapGestureRecognizer) {
      textView.resignFirstResponder()
   }
   
   func keyboardWillShow(notification: NSNotification) {
      animatetextViewWithKeyboard(notification)
   }
   
   
   func keyboardWillHide(notification: NSNotification) {
      animatetextViewWithKeyboard(notification)
   }
}