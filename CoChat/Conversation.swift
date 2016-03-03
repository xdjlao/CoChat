import Foundation

class Conversation: FirebaseType {
    var uid = "none"
    let firstUser: User
    let secondUser: User
    var lastMessage: String
    
    var value: AnyObject {
        return ["firstUID": firstUser.uid, "firstName": firstUser.name, "firstProfileImageURL": firstUser.profileImageURL, "secondUID": secondUser.uid, "secondName": secondUser.name, "secondProfileImageURL": secondUser.profileImageURL, "uid": uid]
    }
    let type = Type.Conversation
    
    init(uid: String, firstUser: User?, firstUID: String?, firstName: String?, firstProfileImageURL: String?, secondUser: User?, secondUID: String?, secondName: String?, secondProfileImageURL: String?) {
        self.uid = uid
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
        self.lastMessage = "None"
    }
    
    required init(fromDictionary dictionary: [NSObject: AnyObject], andUID uid: String) {
        self.uid = uid
        
        let firstName = dictionary["firstName"] as? String ?? "none"
        let firstUID = dictionary["firstUID"] as? String ?? "none"
        self.firstUser = User(name: firstName, profileImageURL: "noneYet", uid: firstUID)
        
        let secondName = dictionary["secondName"] as? String ?? "none"
        let secondUID = dictionary["secondUID"] as? String ?? "none"
        self.secondUser = User(name: secondName, profileImageURL: "noneYet", uid: secondUID)
        
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
}
