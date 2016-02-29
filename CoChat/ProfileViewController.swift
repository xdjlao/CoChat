import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import AFNetworking

class ProfileViewController: UIViewController, FBSDKLoginButtonDelegate {
   
   @IBOutlet var topContainer: UIView!
   @IBOutlet var settingsButton: UIButton!
   
   @IBOutlet weak var profileImageView: UIImageView! {
      didSet {
      let imageHeight = profileImageView.frame.size.height
      profileImageView.layer.cornerRadius = imageHeight / 2
      }
   }
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var recentTableView: UITableView! {
      didSet {
      recentTableView.delegate = self
      recentTableView.dataSource = self
      }
   }
   
   func updateUserLabels() {
      profileImageView.setImageWithURL(NSURL(string: FirebaseManager.manager.user.profileImageURL)!, placeholderImage: UIImage(named: "profileImageDummy"))
      nameLabel.text = FirebaseManager.manager.user.name
   }
   
   override func viewDidAppear(animated: Bool) {
      super.viewDidAppear(animated)
      updateUserLabels()
   }
   
   override func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
      super.loginButtonDidLogOut(loginButton)
      updateUserLabels()
   }
   
   override func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
      super.loginButton(loginButton, didCompleteWithResult: result, error: error)
      updateUserLabels()
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      let size = view.frame.size
      let button = createFBLoginButtonWithPosition(size.width * 0.8, y: size.height * 0.1)
      button.delegate = self
      setUpUI()
   }
   
   override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateUserLabels", name: UIApplicationDidBecomeActiveNotification, object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateUserLabels", name: "FirebaseAuth", object: nil)
   }
   
   override func viewWillDisappear(animated: Bool) {
      super.viewWillDisappear(animated)
      NSNotificationCenter.defaultCenter().removeObserver(self)
   }
   
   func setUpUI (){
      let backgroundColor = Theme.Colors.BackgroundColor.color
      recentTableView.backgroundColor = backgroundColor
      recentTableView.tableFooterView = UIView()
      topContainer.backgroundColor = backgroundColor
      nameLabel.font = Theme.Fonts.NormalTypeFace.font
      settingsButton.hidden = true
   }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 1
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithCellIdentifier(.ProfileCell)
      cell.textLabel?.text = "Let's copy twitch/facebook messenger/hangouts for things to put here?"
      switch (indexPath.section, indexPath.row){
      case (0,0):
         cell.textLabel?.text = "Log Out"
         cell.textLabel?.font = Theme.Fonts.BoldNormalTypeFace.font
         cell.textLabel?.textColor = UIColor.whiteColor()
         cell.backgroundColor = Theme.Colors.ForegroundColor.color
      default:
         break
      }
      return cell
   }
   
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      switch (indexPath.section, indexPath.row){
      case(0,0):
         //Log Out here
         break
      default:
         //Go To Recent Messages Here
         break
      }
   }
   
}
