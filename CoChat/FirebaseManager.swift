import Foundation
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

let baseURL = "https://NAJchat.firebaseio.com"

class FirebaseManager {
    
    var authData: FAuthData?
    
    static let manager = FirebaseManager()
    let ref = Firebase(url: baseURL)
    var user: User {
        didSet {
            print("user did get changed with profileImageURL \(user.profileImageURL)")
            let notification = NSNotification(name: "FirebaseAuth", object: nil)
            NSNotificationCenter.defaultCenter().postNotification(notification)
        }
    }
    var channelMessages: [Message]
    
    init() {
        user = User(withDummyName: "Anonymous", dummyProfileImageURL: "none", dummyUID: "none")
        channelMessages = [Message]()
    }
    
    func handleUserAuthData(authData: FAuthData, withMainQueueCompletionHandler completionHandler: ((user: User?) -> ())? ) {
        self.authData = authData
        let uid = authData.uid
        let name = authData.providerData["displayName"] as? String ?? "No username"
        let profileImageURL = authData.providerData["profileImageURL"] as? String ?? "No URL"
        user = User(name: name, profileImageURL: profileImageURL, uid: uid)
        getUserStoredData()
        completionHandler?(user: user)
    }
    
    func getUserStoredData() {
        ref.childByAppendingPath("User").queryOrderedByKey().queryEqualToValue(user.uid).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            guard let userDictionary = snapshot.value[self.user.uid] as? [NSObject: AnyObject] else { return }
            
            guard let favoriteChannelsUIDs = userDictionary["favoriteChannelsUIDs"] as? [String] else { return }
            
            self.user.favoriteChannels = favoriteChannelsUIDs.map { uid -> Channel in
                return Channel(withDummyTitle: "none", dummyUID: uid)
            }
            
        })
    }
    
    func getRelationshipString(forChildType childType: FirebaseType, parent: FirebaseType) -> String {
        var relationshipString = "none"
        switch (childType.type, parent.type) {
        case (.Channel, .Room):
            relationshipString = "roomUID"
        case (.Message, .Channel):
            relationshipString = "channelUID"
        case (.Message, .User):
            relationshipString = "posterUID"
        case (.Room, .User):
            relationshipString = "hostUID"
        default:
            assertionFailure("no relationship set")
        }
        return relationshipString
    }
    
    func getChildrenForParent<T: FirebaseType, U: FirebaseType>(childType: T, parent: U, withMainQueueCompletionHandler completionHandler: ((children: [T]?) -> ())? ) {
        
        let relationshipString = getRelationshipString(forChildType: childType, parent: parent)
        ref.childByAppendingPath("/\(childType.type)").queryOrderedByChild(relationshipString).queryEqualToValue(parent.uid).observeSingleEventOfType(.Value, withBlock: { snapshot in
            let children = T.arrayFromSnapshot(snapshot)
            NSOperationQueue.mainQueue().addOperationWithBlock({
                completionHandler?(children: children)
            })
        })
    }
    
    func getObjectForID<T: FirebaseType>(type: T, uid: String, withMainQueueCompletionHandler completionHandler: ((child: T?) -> ()) )  {
        type.type.firebase().queryEqualToValue(uid).observeSingleEventOfType(.Value, withBlock: { snapshot in
            let child = T.singleFromSnapshot(snapshot)
            NSOperationQueue.mainQueue().addOperationWithBlock{
                completionHandler(child: child)
            }
        })
    }
    
    func getObjectsByChildValue<T: FirebaseType>(type: T, childProperty: String, childValue: String, withMainQueueCompletionHandler completionHandler: ((children: [T]?) -> ()) )  {
        type.type.firebase().queryOrderedByChild(childProperty).queryEqualToValue(childValue).observeSingleEventOfType(.Value, withBlock: { snapshot in
            let children = T.arrayFromSnapshot(snapshot)
            NSOperationQueue.mainQueue().addOperationWithBlock{
                completionHandler(children: children)
            }
        })
    }
    
    //   func handleSnapshot<T: FirebaseType>(snapshot: FDataSnapshot?, forType type: T) -> [T]? {
    //      guard let snapshot = snapshot, dictionaries = snapshot.value as? [NSObject: AnyObject] else { return nil }
    //      var objects = [T]()
    //      for (uid, dictionary) in dictionaries {
    //         let theUID = uid as? String ?? "No UID"
    //         guard let dictionary = dictionary as? [NSObject: AnyObject] else { return nil }
    //
    //         let object = T(fromDictionary: dictionary, andUID: theUID)
    //         objects.append(object)
    //      }
    //      return objects
    //   }
    //   func handleSingleSnapshot<T: FirebaseType>(snapshot: FDataSnapshot?, forType type: T) -> T? {
    //      guard let snapshot = snapshot, dictionary = snapshot.value as? [NSObject: AnyObject] else { return nil }
    //      let theUID = snapshot.key ?? "No UID"
    //      let object = T(fromDictionary: dictionary, andUID: theUID)
    //      return object
    //   }
}


//MARK - Listeners
extension FirebaseManager {
    func listenForChildForParent<T: FirebaseType, U: FirebaseType>(childType: T, parent: U, withCompletionHandler completionHandler: ((child: T) -> ())? ) -> UInt {
        let relationshipString = getRelationshipString(forChildType: childType, parent: parent)
        return childType.type.firebase().queryOrderedByChild(relationshipString).queryEqualToValue(parent.uid).observeEventType(.ChildAdded, withBlock: { snapshot in
            guard let child = T.singleFromSnapshot(snapshot) else { return }
            completionHandler?(child: child)
        })
    }
    
}

extension FirebaseManager {
    func checkForRoomWithEntryKey(key: String, completionHandler handler: (room: Room?) -> ()) {
        FirebaseManager.manager.getObjectsByChildValue(Room(), childProperty: "entryKey", childValue: key) { rooms in
            guard let room = rooms?[0] else {
                handler(room: nil)
                return
            }
            
            FirebaseManager.manager.getChildrenForParent(Channel(), parent: room) { channels in
                guard let channels = channels else {
                    handler(room: nil)
                    return
                }
                room.channels = channels
                handler(room: room)
            }
        }
    }
    
    //NYI
    func checkForRoomWithUID(uid: String) {
        FirebaseManager.manager.getObjectForID(Room(), uid: uid) { room in
            guard let room = room else { return }
            
            FirebaseManager.manager.getChildrenForParent(Channel(), parent: room) { channels in
                guard let channels = channels else { return }
                room.channels = channels
                
            }
        }
    }
    
    func checkForUniqueEntryKey(entryKey: String, withResultHandler handler: ( Bool -> ())) {
        ref.childByAppendingPath("Room").queryOrderedByChild("posterName").observeSingleEventOfType(.Value, withBlock: { snapshot in
            guard let rooms = Room.arrayFromSnapshot(snapshot) else {
                handler(false)
                return
            }
            for room in rooms {
                if room.password == entryKey {
                    handler(false)
                    return
                }
            }
            handler(true)
        })
    }
}








