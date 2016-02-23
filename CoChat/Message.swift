import UIKit

class Message: FirebaseType {
   var uid = "none"
   let messageText: String
   let timeObject: [NSObject: AnyObject]
   let time: NSDate
   let poster: User
   
   let channel: Channel
   
   var value: AnyObject {
      return ["posterUID": poster.uid, "posterName": poster.name, "posterThumbnail": "NYI", "messageText": messageText, "timeObject": timeObject, "channelUID": channel.uid]
   }
   let type = Type.Message
   
   init(messageText: String, timeObject: [NSObject: AnyObject], poster: User, channel: Channel) {
      self.messageText = messageText
      self.time = NSDate()
      self.timeObject = timeObject
      
      self.poster = poster
      
      self.channel = channel
      
      self.createNew(withCompletionHandler: nil)
   }
   
   required init(fromDictionary dictionary: [NSObject: AnyObject], andUID uid: String) {
      self.uid = uid
      self.messageText = dictionary["messageText"] as? String ?? "failed to get message text"
      print(dictionary["timeObject"])
      self.time = NSDate(timeIntervalSince1970: dictionary["timeObject"] as? NSTimeInterval ?? NSTimeInterval())
      self.timeObject = [NSObject: AnyObject]()
      
      let posterName = dictionary["posterName"] as? String ?? "failed to get posterName"
      let posterUID = dictionary["posterUID"] as? String ?? "failed to get posterUID"
      
      self.poster = User(name: posterName, profileImageURL: "none", uid: posterUID)
      
      let channelUID = dictionary["channelUID"] as? String ?? "failed to get channelUID"
      
      self.channel = Channel(withDummyTitle: "dummy", dummySubtitle: "dummy", dummyUID: channelUID)
   }
   
   init(withDummyMessageText dummyMessageText: String, dummyTime: NSDate, dummyUID: String) {
      uid = dummyUID
      messageText = dummyMessageText
      time = dummyTime
      timeObject = [NSObject: AnyObject]()
      poster = User(withDummyName: "dummy", dummyProfileImageURL: "dummy", dummyUID: "dummy")
      channel = Channel(withDummyTitle: "dummy", dummySubtitle: "dummy", dummyUID: "dummy")
   }
   
   init() {
      let none = "none"
      self.uid = none
      self.messageText = none
      self.timeObject = [NSObject: AnyObject]()
      self.time = NSDate()
      self.poster = User()
      self.channel = Channel()
   }
   
   
}
