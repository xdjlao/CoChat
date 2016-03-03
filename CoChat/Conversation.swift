import Foundation

class Conversation: FirebaseType {
    var uid = "none"
    let firstUser: User
    let secondUser: User
    var lastMessage: String
    
    var value: AnyObject {
        return ["firstUID": firstUser.uid, "firstName": firstUser.name, "firstProfileImageURL": firstUser.profileImageURL, "secondUID": secondUser.uid, "secondName": secondUser.name, "secondProfileImageURL": secondUser.profileImageURL, "lastMessage": lastMessage]
    }
    let type = Type.Conversation
    
    init(firstUser: User?, firstUID: String?, firstName: String?, firstProfileImageURL: String?, secondUser: User?, secondUID: String?, secondName: String?, secondProfileImageURL: String?) {
        if let firstUser = firstUser {
            self.firstUser = firstUser
        } else if let firstName = firstName, firstUID = firstUID, firstProfileImageURL = secondProfileImageURL {
            self.firstUser = User(name: firstName, profileImageURL: firstProfileImageURL, uid: firstUID)
        } else {
            self.firstUser = User(name: "none", profileImageURL: "none", uid: "none")
        }
        if let secondUser = secondUser {
            self.secondUser = secondUser
        } else if let secondName = secondName, secondUID = secondUID, secondProfileImageURL = secondProfileImageURL{
            self.secondUser = User(name: secondName, profileImageURL: secondProfileImageURL, uid: secondUID)
        } else {
            self.secondUser = User(name: "none", profileImageURL: "none", uid: "none")
        }
        self.lastMessage = ""
    }
    
    required init(fromDictionary dictionary: [NSObject: AnyObject], andUID uid: String) {
        self.uid = uid
        
        let firstName = dictionary["firstName"] as? String ?? "none"
        let firstUID = dictionary["firstUID"] as? String ?? "none"
        let firstProfileImageURL = dictionary["firstProfileImageURL"] as? String ?? "none"
        
        self.firstUser = User(name: firstName, profileImageURL: firstProfileImageURL, uid: firstUID)
        
        let secondName = dictionary["secondName"] as? String ?? "none"
        let secondUID = dictionary["secondUID"] as? String ?? "none"
        let secondProfileImageURL = dictionary["secondProfileImageURL"] as? String ?? "none"
        self.secondUser = User(name: secondName, profileImageURL: secondProfileImageURL, uid: secondUID)
        
        self.lastMessage = dictionary["lastMessage"] as? String ?? "None"
    }
    
    init(withDummyUID dummyUID: String, dummyFirstUID: String, dummySecondUID: String) {
        uid = dummyUID
        firstUser = User(name: "none", profileImageURL: "none", uid: "none")
        secondUser = User(name: "none", profileImageURL: "none", uid: "none")
        lastMessage = "none"
    }
    
    init() {
        let none = "none"
        self.uid = none
        firstUser = User(name: "none", profileImageURL: "none", uid: "none")
        secondUser = User(name: "none", profileImageURL: "none", uid: "none")
        lastMessage = none
    }
    static func createNewConversationWith(firstUser: User, secondUser: User, withCompletionHandler handler: ((new: Conversation) -> ())?) {
        let conversation = Conversation(firstUser: firstUser, firstUID: nil, firstName: nil, firstProfileImageURL: nil, secondUser: secondUser, secondUID: nil, secondName: nil, secondProfileImageURL: nil )
        conversation.createNew { new in
            guard let new = new as? Conversation else { return }
            handler?(new: new)
        }
    }
}
