import UIKit
import AFNetworking

extension MessagingViewController: UITableViewDelegate, UITableViewDataSource {
   
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
      if !checkIfLoggedIn() {
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
      
      tableView.sizeToFit()
      tableView.layoutIfNeeded()
      textView.sizeToFit()
      textView.layoutIfNeeded()
      textView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8)
      let height = textView.sizeThatFits(CGSizeMake(textView.frame.size.width, CGFloat.max)).height
      textView.contentSize.height = height
      print(textView.frame.size.height)
      print("Content size \(textView.contentSize.height)")
      
      if textView.frame.size.height < textView.contentSize.height {
         
         buttonsContainer.removeConstraint(buttonToTableViewConstraint)
         let newHeight = textView.contentSize.height
         var frame = textView.frame
         
         UIView.animateWithDuration(0.5, delay: 0.0, options: [], animations: { () -> Void in
            frame.size.height = newHeight + 10.00
            }, completion: nil)
      }
      
   }
   //MARK - TableView Delegate Methods
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let currentMessage = messages[indexPath.row]
      
      if currentMessage.poster.name == user?.name {
         let cell = tableView.dequeueReusableCellWithIdentifier("UserMessageCell") as! UserMessageCell
         cell.messageLabel.text = currentMessage.messageText
         
         if let user = user {
            cell.profileImageView.setImageWithURL(NSURL(string: user.profileImageURL)!, placeholderImage: UIImage(named: "profileImageDummy"))
         } else {
            cell.profileImageView.setImageWithURL(NSURL(string: "www.jerrylao.com")!, placeholderImage: UIImage(named: "profileImageDummy"))
         }
         cell.selectionStyle = UITableViewCellSelectionStyle.None
         return cell
      }
         
      else {
         let cell = tableView.dequeueReusableCellWithIdentifier("GeneralMessageCell") as! GeneralMessageCell
         cell.messageLabel.text = currentMessage.messageText
         user?.profileImage { (profileImage) in
            cell.profileImageView.image = profileImage
         }
         cell.selectionStyle = UITableViewCellSelectionStyle.None
         return cell
      }
   }
   
   func generalMessageCellWillDisplay(generalCell: GeneralMessageCell, indexPath: NSIndexPath) {
      generalCell.profileImageView.alpha = 0.0
      generalCell.messageLabel.alpha = 0.0
      UIView.animateWithDuration(0.5, delay: 0.0, options: [], animations: { () -> Void in
         generalCell.alpha = 1.0
         generalCell.messageLabel.alpha = 1.0
         }, completion: { (Bool) -> Void in
            print("General Message Was Displayed")
      })
   }
   
   
   func userMessageCellWillDisplay(userCell: UserMessageCell, indexPath: NSIndexPath) {
      userCell.profileImageView.alpha = 0.0
      userCell.messageLabel.alpha = 0.0
      UIView.animateWithDuration(0.5, delay: 0.0, options: [], animations: { () -> Void in
         userCell.profileImageView.alpha = 1.0
         userCell.messageLabel.alpha = 1.0
         }, completion: { (Bool) -> Void in
            print("User Message Was Displayed")
      })
   }
   
   
   func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
      if indexPath.row == messages.count - 1 {
         if let generalCell = cell as? GeneralMessageCell {
            generalMessageCellWillDisplay(generalCell, indexPath: indexPath)
            tableView.scrollToBottom()
            
         }
         
         if let userCell = cell as? UserMessageCell {
            userMessageCellWillDisplay(userCell, indexPath: indexPath)
            tableView.scrollToBottom()
            
         }
      }
   }
   
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return messages.count
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
   
   //Animate cell appearance and scroll to most recently posted cell
   
   
   func uiSetup() {
      textView.delegate = self
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "textViewBeganEditing", name: UITextViewTextDidChangeNotification, object: nil)
      textView.scrollEnabled = false
      registerNibs()
      
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