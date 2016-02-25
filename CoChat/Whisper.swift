import UIKit
import Firebase

class Whisper: DualQueriedType {
   var uid = "none"
   let text: String
   let timeObject: [NSObject: AnyObject]
   let time: NSDate
   let sender: User
   let reciever: User
   
   var value: AnyObject {
      return [ sender.uid : [ "senderName": sender.name, "receiverUID": reciever.uid, "recieverName": reciever.name, "recieverThumbnail": "NYI", "messageText": text, "timeObject": timeObject]]
   }
   let type = Type.Message
   
   init(text: String, timeObject: [NSObject: AnyObject], sender: User, reciever: User) {
      self.text = text
      self.time = NSDate()
      self.timeObject = timeObject
      
      self.sender = sender
      self.reciever = reciever
      
      self.createNew(withCompletionHandler: nil)
   }
   
   convenience required init(fromDictionary dictionary: [NSObject: AnyObject], andUID: String) {
      self.init(fromDictionary: [NSObject: AnyObject](), uid: String(), andCreatorUID: String())
      assertionFailure()
   }
   
   required init(fromDictionary dictionary: [NSObject: AnyObject], uid: String, andCreatorUID creatorUID: String) {
      self.uid = uid
      self.text = dictionary["messageText"] as? String ?? "failed to get message text"
      self.time = NSDate(timeIntervalSince1970: dictionary["timeObject"] as? NSTimeInterval ?? NSTimeInterval())
      self.timeObject = [NSObject: AnyObject]()
      
      let senderName = dictionary["senderName"] as? String ?? "failed to get senderName"
      
      self.sender = User(name: senderName, profileImageURL: "none", uid: creatorUID)
      
      let recieverName = dictionary["recieverName"] as? String ?? "failed to get recieverName"
      let recieverUID = dictionary["recieverUID"] as? String ?? "failed to get receiverUID"
      
      self.reciever = User(name: recieverName, profileImageURL: "none", uid: recieverUID)
   }
   
   init(withDummyText dummyText: String, dummyTime: NSDate, dummyUID: String) {
      uid = dummyUID
      text = dummyText
      time = dummyTime
      timeObject = [NSObject: AnyObject]()
      sender = User(withDummyName: "dummy", dummyProfileImageURL: "dummy", dummyUID: "dummy")
      reciever = User(withDummyName: "dummy", dummyProfileImageURL: "dummy", dummyUID: "dummy")
   }
   
   init() {
      let none = "none"
      self.uid = none
      self.text = none
      self.timeObject = [NSObject: AnyObject]()
      self.time = NSDate()
      self.sender = User()
      self.reciever = User()
   }
   
   
}
