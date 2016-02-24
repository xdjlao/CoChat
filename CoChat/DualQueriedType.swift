import Firebase
import UIKit


protocol DualQueriedType: FirebaseType {
   init(fromDictionary: [NSObject: AnyObject], uid: String, andCreatorUID creatorUID: String)
}

extension DualQueriedType {
   func saveSelf() {
      guard let value = value as? [NSObject: AnyObject] else { return }
      switch type {
      case .Whisper:
         assertionFailure()
         Firebase(url: baseURL).childByAppendingPath("/\(uid)").updateChildValues(value)
      default: assertionFailure()
      }
   }
   
   func createNew(forCreatorUID creatorUID: String, withCompletionHandler completionHandler: ((new: DualQueriedType) -> ())? ) {
      switch type {
      case .Whisper:
         type.firebase().childByAppendingPath(creatorUID).childByAutoId().setValue(value, withCompletionBlock: { (error, firebase) -> Void in
            if let error = error {
               print(error)
            }
            self.uid = firebase.key
            completionHandler?(new: self)
         })
      default: assertionFailure()
      }
   }
   
   static func arrayFromSnapshot(snapshot: FDataSnapshot?, withCreatorUID creatorUID: String) -> [Self]? {
      guard let snapshot = snapshot, dictionaries = snapshot.value as? [NSObject: AnyObject] else { return nil }
      var objects = [Self]()
      for (uid, dictionary) in dictionaries {
         let theUID = uid as? String ?? "No UID"
         guard let dictionary = dictionary as? [NSObject: AnyObject] else { return nil }
         
         let object = Self(fromDictionary: dictionary, uid: theUID, andCreatorUID: creatorUID)
         objects.append(object)
      }
      return objects
   }
   static func singleFromSnapshot(snapshot: FDataSnapshot?, withCreatorUID creatorUID: String) -> Self? {
      guard let snapshot = snapshot, dictionary = snapshot.value as? [NSObject: AnyObject] else { return nil }
      let theUID = snapshot.key ?? "No UID"
      let object = Self(fromDictionary: dictionary, uid: theUID, andCreatorUID: creatorUID)
      return object
   }
   
   
}
