import UIKit
import Firebase

class User: FirebaseType {
   var uid = "none"
   let name: String
   let profileImageURL: String
   
   var favoriteChannelsUIDs = [String]()
   var favoriteChannels = [Channel]()
   
   func profileImage(handler: (profileImage: UIImage?) -> () ) {
      handler(profileImage: UIImage(named: "profileImageDummy"))
   }
   
   var value: AnyObject {
      return ["name": name, "profileImageURL": profileImageURL, "favoriteChannelsUIDs": favoriteChannelsUIDs]
   }
    
   let type = Type.User
   
   init(name: String, profileImageURL: String, uid: String) {
      self.name = name
      self.profileImageURL = profileImageURL
      self.uid = uid
   }
   
   required init(fromDictionary dictionary: [NSObject : AnyObject], andUID uid: String) {
      self.uid = uid
      self.name = "blech"
      self.profileImageURL = "blech"
      self.favoriteChannelsUIDs = dictionary["favoriteChannelsUIDs"] as? [String] ?? [String]()
   }
   
   init(withDummyName dummyName: String, dummyProfileImageURL: String, dummyUID: String) {
      uid = dummyUID
      name = dummyName
      profileImageURL = dummyProfileImageURL
   }
   
   init() {
      let none = "none"
      self.uid = none
      self.name = none
      self.profileImageURL = none
      self.favoriteChannelsUIDs = [String]()
      self.favoriteChannels = [Channel]()
   }
}
