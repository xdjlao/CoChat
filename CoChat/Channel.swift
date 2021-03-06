import UIKit
import Firebase

class Channel: FirebaseType {
    var uid = "none"
    let title: String
    
    var privateChannel: Int
    var password: String
    
    var room: Room
    
    var value: AnyObject {
        return ["title": title, "roomTitle": room.title, "roomUID": room.uid, "privateChannel": privateChannel, "password": password]
    }
    
    let type = Type.Channel
    
    init(title: String, privateChannel: Int, password: String, room: Room) {
        self.title = title
        
        self.privateChannel = privateChannel
        self.password = password
        
        self.room = room
   }
   
   static func createNewChannelWith(title: String, room: Room, privateChannel: Int, password: String, withCompletionHandler handler: ((new: Channel) -> ())?) {
      let channel = Channel(title: title, privateChannel: privateChannel, password: password, room: room)
      channel.createNew { new in
         guard let new = new as? Channel else { return }
         handler?(new: new)
      }
   }
    
    required init(fromDictionary dictionary: [NSObject: AnyObject], andUID uid: String) {
        self.uid = uid
        self.title = dictionary["title"] as? String ?? "failed to get title"
        
        self.privateChannel = dictionary["privateChannel"] as? Int ?? 0
        self.password = dictionary["password"] as? String ?? "none"
        
        let roomName = dictionary["roomTitle"] as? String ?? "failed to get roomName"
        let roomUID = dictionary["roomUID"] as? String ?? "failed to get roomUID"
        
        self.room = Room(withDummyTitle: roomName, dummyUID: roomUID)
    }
    
    init(withDummyTitle dummyTitle: String, dummyUID: String) {
        uid = dummyUID
        title = dummyTitle
        privateChannel = 0
        password = "none"
        
        room = Room(withDummyTitle: "dummy", dummyUID: "dummy")
    }
    
    //Merge these Two
    init(withTempTitle tempTitle: String, tempPrivateChannel: Int, tempPassword: String, roomName:String) {
        title = tempTitle
        privateChannel = tempPrivateChannel
        password = tempPassword
        self.room = Room(withDummyTitle:roomName, dummyUID: "channel")
    }
    
    init() {
        let none = "none"
        self.uid = none
        self.title = none
        self.privateChannel = 0
        self.password = none
        self.room = Room(withDummyTitle: "dummy", dummyUID: "dummy")
    }
}