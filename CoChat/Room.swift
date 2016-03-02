import UIKit
import Firebase

class Room: FirebaseType {
   var uid = "none"
   let title: String
   
   var privateRoom: Int
   var password: String
   
   var channels: [Channel]
   
   let host: User
   
   var value: AnyObject {
      return ["title": title, "hostName": host.name, "hostUID": host.uid, "privateRoom": privateRoom, "entryKey": password]
   }
   let type = Type.Room
   
   private init(title: String, host: User, privateRoom: Int, password: String) {
      self.title = title
      self.host = host
      
      self.privateRoom = privateRoom
      self.password = password
      
      self.channels = [Channel]()
   }
   
   static func createNewRoomWith(title: String, host: User, privateRoom: Int, password: String, withCompletionHandler handler: ((new: Room) -> ())?) {
      let room = Room(title: title, host: host, privateRoom: privateRoom, password: password)
      room.createNew { new in
        
         guard let new = new as? Room else { return }
         handler?(new: new)
      }
   }
   
   required init(fromDictionary dictionary: [NSObject: AnyObject], andUID uid: String) {
      self.uid = uid
      self.title = dictionary["title"] as? String ?? "failed to get title"
      
      self.privateRoom = dictionary["privateRoom"] as? Int ?? 0
      self.password = dictionary["entryKey"] as? String ?? "no password"
      
      let hostName = dictionary["hostName"] as? String ?? "failed to get hostName"
      let hostUID = dictionary["hostUID"] as? String ?? "failed to get hostUID"
      
      self.channels = [Channel]() //PLACEHOLDER
      
      self.host = User(name: hostName, profileImageURL: "none", uid: hostUID)
   }
   
   init(withDummyTitle dummyTitle: String, dummyUID: String) {
      uid = dummyUID
      title = dummyTitle
    
      privateRoom = 0
      password = "none"
      
      self.channels = [Channel]() //PLACEHOLDER
      
      host = User(withDummyName: "dummy", dummyProfileImageURL: "dummy", dummyUID: "dummy")
   }
   init() {
      let none = "none"
      self.uid = none
      self.title = none
      self.privateRoom = 0
      self.password = none
      self.channels = [Channel]()
      self.host = User()
   }
}