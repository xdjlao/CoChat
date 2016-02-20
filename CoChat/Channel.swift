import UIKit
import Firebase

class Channel: FirebaseType {
    var uid = "none"
    let title: String
    let subtitle: String
    
    var privateChannel: Int
    var password: String
    
    let room: Room
    
    var value: AnyObject {
        return ["title": title, "subtitle": subtitle, "roomTitle": room.title, "roomUID": room.uid, "privateChannel": privateChannel, "password": password]
    }
    
    let type = Type.Channel
    
    init(title: String, subtitle: String, privateChannel: Int, password: String, room: Room) {
        self.title = title
        self.subtitle = subtitle
        
        self.privateChannel = privateChannel
        self.password = password
        
        self.room = room
        
        self.createNew(withCompletionHandler: nil)
    }
    
    required init(fromDictionary dictionary: [NSObject: AnyObject], andUID uid: String) {
        self.uid = uid
        self.title = dictionary["title"] as? String ?? "failed to get title"
        self.subtitle = dictionary["subtitle"] as? String ?? "failed to get subtitle"
        
        self.privateChannel = dictionary["privateChannel"] as? Int ?? 0
        self.password = dictionary["password"] as? String ?? "none"
        
        let roomName = dictionary["hostName"] as? String ?? "failed to get hostName"
        let roomUID = dictionary["hoseUID"] as? String ?? "failed to get hostUID"
        
        self.room = Room(withDummyTitle: roomName, dummySubtitle: "dummy", dummyUID: roomUID)
    }
    
    init(withDummyTitle dummyTitle: String, dummySubtitle: String, dummyUID: String) {
        uid = dummyUID
        title = dummyTitle
        subtitle = dummySubtitle
        
        privateChannel = 0
        password = "none"
        
        room = Room(withDummyTitle: "dummy", dummySubtitle: "dummy", dummyUID: "dummy")
    }
    
    init() {
        let none = "none"
        self.uid = none
        self.title = none
        self.privateChannel = 0
        self.password = none
        self.subtitle = none
        self.room = Room(withDummyTitle: "dummy", dummySubtitle: "dummy", dummyUID: "dummy")
    }
    
}