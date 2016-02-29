import Foundation

class FetchOperation: NSOperation {
   
   var operationBlock: ( () -> () )!
   
   override func main() {
      operationBlock()
   }
}