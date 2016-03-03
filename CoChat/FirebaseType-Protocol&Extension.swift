import Firebase
import UIKit

enum Type: String {
    case User = "User"
    case Message = "Message"
    case Room = "Room"
    case Channel = "Channel"
    case Conversation = "Conversation"
    case Whisper = "Whisper"
    
    func firebase() -> Firebase {
        return Firebase(url: baseURL).childByAppendingPath("/" + self.rawValue)
    }
}

protocol FirebaseType: class {
    var uid: String { get set }
    var value: AnyObject { get }
    func saveSelf()
    func createNew(withCompletionHandler completionHandler: ((new: FirebaseType) -> ())? )
    var type: Type { get }
    
    init(fromDictionary dictionary: [NSObject: AnyObject], andUID: String)
}

extension FirebaseType {
    func saveSelf() {
        guard let value = value as? [NSObject: AnyObject] else { return }
        switch type {
        case .User:
            Firebase(url: baseURL).childByAppendingPath("User").childByAppendingPath("/\(uid)").updateChildValues(value)
        case .Message, .Room , .Channel, .Whisper:
            assertionFailure()
            Firebase(url: baseURL).childByAppendingPath("/\(uid)").updateChildValues(value)
        case .Conversation:
            Firebase(url: baseURL).childByAppendingPath("Conversation").childByAppendingPath("/\(uid)").updateChildValues(value)
        }
    }
    
    func createNew(withCompletionHandler completionHandler: ((new: FirebaseType) -> ())? ) {
        switch type {
        case .User:
            type.firebase().childByAppendingPath("/\(uid)").setValue(value)
        case .Message, .Room , .Channel:
            type.firebase().childByAutoId().setValue(value, withCompletionBlock: { (error, firebase) -> Void in
                if let error = error {
                    print(error)
                }
                self.uid = firebase.key
                completionHandler?(new: self)
            })
        case .Conversation:
            type.firebase().childByAutoId().setValue(value, withCompletionBlock: { error, firebase in
                if let error = error {
                    print(error)
                }
                self.uid = firebase.key
                completionHandler?(new:self)
            })
        default: assertionFailure()
        }
    }
    
    static func arrayFromSnapshot(snapshot: FDataSnapshot?) -> [Self]? {
        guard let snapshot = snapshot, dictionaries = snapshot.value as? [NSObject: AnyObject] else { return nil }
        var objects = [Self]()
        for (uid, dictionary) in dictionaries {
            let theUID = uid as? String ?? "No UID"
            guard let dictionary = dictionary as? [NSObject: AnyObject] else { return nil }
            
            let object = Self(fromDictionary: dictionary, andUID: theUID)
            objects.append(object)
        }
        return objects
    }
    static func singleFromSnapshot(snapshot: FDataSnapshot?) -> Self? {
        guard let snapshot = snapshot, dictionary = snapshot.value as? [NSObject: AnyObject] else { return nil }
        let theUID = snapshot.key ?? "No UID"
        let object = Self(fromDictionary: dictionary, andUID: theUID)
        return object
    }
}
