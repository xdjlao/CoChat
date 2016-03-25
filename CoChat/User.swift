import UIKit
import Firebase

class User: FirebaseType {
    var uid = "none"
    var name: String
    let profileImageURL: String
    
    var favoriteChannels = [Channel]()
    var conversationPartners = [User]()
    
    func profileImage(handler: (profileImage: UIImage?) -> () ) {
        handler(profileImage: UIImage(named: "profileImageDummy"))
    }
    
    var value: AnyObject {
        let favoriteChannelsUIDs = favoriteChannels.map { channel -> String in
            return channel.uid
        }
        let conversationPartnersUIDs = conversationPartners.map { partner -> String in
            return partner.uid
        }
        return ["name": name, "profileImageURL": profileImageURL, "favoriteChannelsUIDs": favoriteChannelsUIDs, "conversationPartnersUIDs": conversationPartnersUIDs]
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
        let favoriteChannelUIDs = dictionary["recentRoomsUIDs"] as? [String] ?? [String]()
        self.favoriteChannels = favoriteChannelUIDs.map { uid -> Channel in
            return Channel(withDummyTitle: "none", dummyUID: uid)
        }
        let conversationPartnersUIDs = dictionary["conversationPartnersUIDs"] as? [String] ?? [String]()
        self.conversationPartners = conversationPartnersUIDs.map { uid -> User in
            return User(name: "none", profileImageURL: "none", uid: uid)
        }
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
    }
}
