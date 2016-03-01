import UIKit

class Message: DualQueriedType {
    var uid = "none"
    let text: String
    let timeObject: [NSObject: AnyObject]
    let time: NSDate
    let poster: User
    
    let channel: Channel
    
    var value: AnyObject {
        return ["posterUID": poster.uid, "posterName": poster.name, "posterThumbnail": poster.profileImageURL, "text": text, "timeObject": timeObject, "channelUID": channel.uid]
    }
    let type = Type.Message
    
    static func createNewMessageWith(text: String, timeObject: [NSObject: AnyObject], poster: User, channel: Channel?, withCompletionHandler handler: ((new: Message) -> ())?) {
        let message = Message(text: text, timeObject: timeObject, poster: poster, channel: channel ?? Channel())
        message.createNew(forCreatorUID: (channel ?? Channel()).uid) { newMessage in
            guard let newMessage = newMessage as? Message else { return }
            handler?(new: newMessage)
        }
    }
    static func createNewWhisperWith(text: String, timeObject: [NSObject: AnyObject], poster: User, conversation: Conversation, withCompletionHandler handler: ((new: Message) -> ())?) {
        let value = ["posterUID": poster.uid, "posterName": poster.name, "posterThumbnail": poster.profileImageURL, "text": text, "timeObject": timeObject]
        FirebaseManager.manager.ref.childByAppendingPath("Conversation").childByAppendingPath(conversation.uid).childByAppendingPath("Whispers").childByAutoId().setValue(value, withCompletionBlock: { error, firebase -> Void in
            if let error = error {
                print(error)
            }            
        })
    }
    
    init(text: String, timeObject: [NSObject: AnyObject], poster: User, channel: Channel) {
        self.text = text
        self.time = NSDate()
        self.timeObject = timeObject
        
        self.poster = poster
        
        self.channel = channel
    }
    
    required init(fromDictionary dictionary: [NSObject: AnyObject], uid: String, andCreatorUID creatorUID: String) {
        self.uid = uid
        
        self.text = dictionary["text"] as? String ?? "failed to get message text"
        self.time = NSDate(timeIntervalSince1970: dictionary["timeObject"] as? NSTimeInterval ?? NSTimeInterval())
        self.timeObject = [NSObject: AnyObject]()
        
        let posterName = dictionary["posterName"] as? String ?? "failed to get posterName"
        let posterUID = dictionary["posterUID"] as? String ?? "failed to get posterUID"
        let posterProfileImageURL = dictionary["posterThumbnail"] as? String ?? "failed to get posterThumbnail"
        
        self.poster = User(name: posterName, profileImageURL: posterProfileImageURL, uid: posterUID)
        
        let channelUID = dictionary["channelUID"] as? String ?? "failed to get channelUID"
        
        self.channel = Channel(withDummyTitle: "dummy", dummyUID: channelUID)
    }
    
    convenience required init(fromDictionary dictionary: [NSObject: AnyObject], andUID uid: String) {
        self.init(fromDictionary: [NSObject: AnyObject](), uid: String(), andCreatorUID: String())
        assertionFailure()
    }
    
    init(withDummytext dummytext: String, dummyTime: NSDate, dummyUID: String) {
        uid = dummyUID
        text = dummytext
        time = dummyTime
        timeObject = [NSObject: AnyObject]()
        poster = User(withDummyName: "dummy", dummyProfileImageURL: "dummy", dummyUID: "dummy")
        channel = Channel(withDummyTitle: "dummy", dummyUID: "dummy")
    }
    
    init() {
        let none = "none"
        self.uid = none
        self.text = none
        self.timeObject = [NSObject: AnyObject]()
        self.time = NSDate()
        self.poster = User()
        self.channel = Channel()
    }
    
    
}
