import UIKit
import Firebase

class Room: FirebaseType {
    var uid = "none"
    let title: String
    let subtitle: String
    
    var privateRoom: Int
    var password: String
    
    var channels: [Channel]
    
    let host: User
    
    var value: AnyObject {
        return ["title": title, "subtitle": subtitle, "hostName": host.name, "hostUID": host.uid, "privateRoom": privateRoom, "entryKey": password]
    }
    let type = Type.Room
    
    init(title: String, subtitle: String, host: User, privateRoom: Int, password: String, withCompletionHandler handler: ((new: Room) -> ())?) {
        self.title = title
        self.subtitle = subtitle
        self.host = host
        
        self.privateRoom = privateRoom
        self.password = password
        
        self.channels = [Channel]()
        self.createNew { new in
            guard let new = new as? Room else { return }
            let main = Channel(title: "Main", subtitle: "Talk about things here.", privateChannel: 0, password: "none", room: new)
            self.channels.append(main)
            handler?(new: self)
        }
    }
    
    required init(fromDictionary dictionary: [NSObject: AnyObject], andUID uid: String) {
        self.uid = uid
        self.title = dictionary["title"] as? String ?? "failed to get title"
        self.subtitle = dictionary["subtitle"] as? String ?? "failed to get subtitle"
        
        self.privateRoom = dictionary["privateRoom"] as? Int ?? 0
        self.password = dictionary["password"] as? String ?? "no password"
        
        let hostName = dictionary["hostName"] as? String ?? "failed to get hostName"
        let hostUID = dictionary["hostUID"] as? String ?? "failed to get hostUID"
        
        self.channels = [Channel]() //PLACEHOLDER
        
        self.host = User(name: hostName, profileImageURL: "none", uid: hostUID)
    }
    
    init(withDummyTitle dummyTitle: String, dummySubtitle: String, dummyUID: String) {
        uid = dummyUID
        title = dummyTitle
        subtitle = dummySubtitle
        
        privateRoom = 0
        password = "none"
        
        self.channels = [Channel]() //PLACEHOLDER
        
        host = User(withDummyName: "dummy", dummyProfileImageURL: "dummy", dummyUID: "dummy")
    }
    init() {
        let none = "none"
        self.uid = none
        self.title = none
        self.subtitle = none
        self.privateRoom = 0
        self.password = none
        self.channels = [Channel]()
        self.host = User()
    }
}