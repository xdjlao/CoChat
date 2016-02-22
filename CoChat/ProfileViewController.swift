import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class ProfileViewController: UIViewController, FBSDKLoginButtonDelegate {
   
   var user: User? {
      didSet{
      guard let nameLabel = nameLabel else { return }
      guard let user = user else { return }
      nameLabel.text = user.name
      }
   }
   
   @IBOutlet weak var profileImageView: UIImageView! {
      didSet {
      let imageHeight = profileImageView.frame.size.height
      profileImageView.layer.cornerRadius = imageHeight / 2
      }
   }
   @IBOutlet weak var nameLabel: UILabel! {
      didSet {
      guard let user = user else { return }
      nameLabel.text = user.name
      }
   }
   @IBOutlet weak var recentTableView: UITableView! {
      didSet {
      recentTableView.delegate = self
      recentTableView.dataSource = self
      }
   }
   @IBOutlet weak var followingCountLabel: UILabel! {
      didSet {
      followingCountLabel.text = "Jerry we don't"
      }
   }
   @IBOutlet weak var followerCountLabel: UILabel! {
      didSet {
      followerCountLabel.text = "have followers?"
      }
   }
   override func viewDidAppear(animated: Bool) {
      super.viewDidAppear(animated)
      user = FirebaseManager.manager.user
   }
   override func viewDidLoad() {
      super.viewDidLoad()
      let size = view.frame.size
      let button = createFBLoginButtonWithPosition(size.width * 0.8, y: size.height * 0.1)
      button.delegate = self
   }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 0
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithCellIdentifier(.ProfileCell)
      cell.textLabel?.text = "Let's copy twitch/facebook messenger/hangouts for things to put here?"
      return cell
   }  
}
