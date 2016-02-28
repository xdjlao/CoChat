import Foundation
import Firebase


class FirebaseArray<T: FirebaseType> {
   var items = [T]() {
      didSet {
     
      if let sortFunction = sortFunction {
         items.sortInPlace(sortFunction)
      }
      }
   }
   
   let manager = FirebaseManager.manager
   
   var sortFunction: ((T, T) -> Bool)?
   
   var ref: Firebase!
   var queryOrderedByChild: String?
   var queryEqualToValue: AnyObject?
   
   var queryLimitedToLast: UInt?
   
   var queryStartingAtValue: AnyObject?
   var eventType: FEventType!
   var completionHandlerForChildAdded: (() -> ())?
   var completionHandlerForValue: (Int -> ())?
   
 
   func onceQueryForValue() {
      var query = ref.queryLimitedToLast(10)
      if let queryOrderedByChild = queryOrderedByChild {
         query = query.queryOrderedByChild(queryOrderedByChild)
      }
      if let queryEqualToValue = queryEqualToValue {
         query = query.queryEqualToValue(queryEqualToValue)
      }
      if let queryStartingAtValue = queryStartingAtValue {
         query = query.queryStartingAtValue(queryStartingAtValue)
      }
      
//      query.observeSingleEventOfType(.Value, withBlock: { snapshot in
      Firebase(url: "https://najchat.firebaseio.com/Message").queryLimitedToLast(10).queryOrderedByChild("channelUID").queryEqualToValue("-KBQ13cOyr0OGZLF1_zj").observeSingleEventOfType(.Value, withBlock: { snapshot in
         print(snapshot)
         
         guard let snapshot = snapshot else { return }
         guard let items = T.arrayFromSnapshot(snapshot) else { return }
         self.queryStartingAtValue = items.last?.uid
         NSOperationQueue.mainQueue().addOperationWithBlock {
//            for item in items {
//               self.items.append(item)
//               self.completionHandlerForChildAdded?()
//            }
            self.items.appendContentsOf(items)
            self.completionHandlerForValue?(3)
         }
      })
   }
   
   func startListener(forLast last: UInt) -> UInt {
      
      var query = ref.queryOrderedByChild(queryOrderedByChild)
      
      if let queryEqualToValue = queryEqualToValue {
         query = query.queryEqualToValue(queryEqualToValue)
      }
      
      query = query.queryLimitedToLast(last)
      
      return query.observeEventType(eventType, withBlock: { snapshot in
         guard let snapshot = snapshot else { return }
         guard let item = T.singleFromSnapshot(snapshot) else { return }
         NSOperationQueue.mainQueue().addOperationWithBlock {
            if !self.items.contains({ (element: FirebaseType) -> Bool in
               if element.uid == item.uid {
               return true
               } else {
                  return false
               }
            }) {
               self.items.append(item)
               self.completionHandlerForChildAdded?()
            }
         }
      })
   }
   
   func startListenerForAll() -> UInt {
      var query = ref.queryOrderedByChild(queryOrderedByChild)
      
      if let queryEqualToValue = queryEqualToValue {
         query = query.queryEqualToValue(queryEqualToValue)
      }
      
      return query.observeEventType(eventType, withBlock: { snapshot in
         guard let snapshot = snapshot else { return }
         guard let item = T.singleFromSnapshot(snapshot) else { return }
         NSOperationQueue.mainQueue().addOperationWithBlock {
            self.items.append(item)
            self.completionHandlerForChildAdded?()
         }
      })
   }
}