import UIKit
import Firebase

class User: FirebaseType {
    var uid = "none"
    let name: String
    let profileImageURL: String
    let email:String?
    let password:String?
    
    var favoriteChannels = [Channel]()
    var conversationPartners = [User]()
    
    func profileImage(handler: (profileImage: UIImage?) -> () ) {
        handler(profileImage: UIImage(named: "blendColorLogo-60"))
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
        self.email = "FB auth"
        self.password = "FB auth"
    }
    
    init(withEmail email:String, name:String, profileImageURL:String, uid:String, password:String){
        self.email = email
        self.name = name
        self.profileImageURL = profileImageURL
        self.uid = uid
        self.password = password
    }
    
    static func createNewUserWith(email: String, name: String, password: String, uid:String, profileImageURl:String, withCompletionHandler handler: ((new: User) -> ())?) {
        let user = User(withEmail: email, name: name, profileImageURL: "", uid: uid, password: password)
        user.createNew { (new) in
            guard let new = new as? User else {return}
            handler?(new: new)
        }
    }

    required init(fromDictionary dictionary: [NSObject : AnyObject], andUID uid: String) {
        self.uid = uid
        self.name = "blech"
        self.profileImageURL = "blech"
        self.email = "FB auth"
        self.password = "FB auth"
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
        email = "FB auth"
        password = "FB auth"
    }
    
    init() {
        let none = "none"
        uid = none
        name = none
        profileImageURL = none
        email = "FB auth"
        password = "FB auth"
    }
}
