import UIKit

class Message: FirebaseType {
    var uid = "none"
    let messageText: String
    let timeStamp: String
    let poster: User
    
    let channel: Channel
    
    var value: AnyObject {
        return ["posterUID": poster.uid, "posterName": poster.name, "posterThumbnail": "NYI", "messageText": messageText, "timeStamp": timeStamp, "channelUID": channel.uid]
    }
    let type = Type.Message
    
    init(messageText: String, timeStamp: String, poster: User, channel: Channel) {
        self.messageText = messageText
        self.timeStamp = timeStamp
        self.poster = poster
        
        self.channel = channel
        
        self.createNew(withCompletionHandler: nil)
    }
    
    required init(fromDictionary dictionary: [NSObject: AnyObject], andUID uid: String) {
        self.uid = uid
        self.messageText = dictionary["messageText"] as? String ?? "failed to get message text"
        self.timeStamp = dictionary["timeStamp"] as? String ?? "failed to get timeStamp"
        
        let posterName = dictionary["posterName"] as? String ?? "failed to get posterName"
        let posterUID = dictionary["posterUID"] as? String ?? "failed to get posterUID"
        
        self.poster = User(name: posterName, profileImageURL: "none", uid: posterUID)
        
        let channelUID = dictionary["channelUID"] as? String ?? "failed to get channelUID"
        
        self.channel = Channel(withDummyTitle: "dummy", dummySubtitle: "dummy", dummyUID: channelUID)
    }
    
    init(withDummyMessageText dummyMessageText: String, dummyTimeStamp: String, dummyUID: String) {
        uid = dummyUID
        messageText = dummyMessageText
        timeStamp = dummyTimeStamp
        poster = User(withDummyName: "dummy", dummyProfileImageURL: "dummy", dummyUID: "dummy")
        channel = Channel(withDummyTitle: "dummy", dummySubtitle: "dummy", dummyUID: "dummy")
    }
    
    init() {
        let none = "none"
        self.uid = none
        self.messageText = none
        self.timeStamp = none
        self.poster = User()
        self.channel = Channel()
    }
    
    
}
