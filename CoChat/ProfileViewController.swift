import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import AFNetworking

class ProfileViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var user: User? //{
       // didSet{
            //guard let user = user else { return }
//            if let nameLabel = nameLabel {
//                nameLabel.text = user.name
//            }
//            if let profileImageView = profileImageView {
//                profileImageView.setImageWithURL(NSURL(string: user.profileImageURL)!, placeholderImage: UIImage(named: "profileImageDummy"))
//                let imageHeight = profileImageView.frame.size.height
//                profileImageView.layer.cornerRadius = imageHeight / 2
//            }
        //}
    //}
    
    @IBOutlet var topContainer: UIView!
    
    // @IBOutlet var settingsButton: UIButton!
    
//    @IBOutlet weak var profileImageView: UIImageView! {
//        didSet {
//            guard let user = user else { return }
//            profileImageView.setImageWithURL(NSURL(string: user.profileImageURL)!, placeholderImage: UIImage(named: "profileImageDummy"))
//            let imageHeight = profileImageView.frame.size.height
//            profileImageView.layer.cornerRadius = imageHeight / 2
//        }
//    }
//    @IBOutlet weak var nameLabel: UILabel! {
//        didSet {
//            guard let user = user else { return }
//            nameLabel.text = user.name
//        }
//    }
    @IBOutlet weak var recentTableView: UITableView! {
        didSet {
            recentTableView.delegate = self
            recentTableView.dataSource = self
        }
    }
//    @IBOutlet weak var followingCountLabel: UILabel! {
//        didSet {
//            followingCountLabel.text = "Jerry we don't"
//        }
//    }
//    @IBOutlet weak var followerCountLabel: UILabel! {
//        didSet {
//            followerCountLabel.text = "have followers?"
//        }
//    }
   override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      user = FirebaseManager.manager.user
   }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
      
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let size = view.frame.size
        let button = createFBLoginButtonWithPosition(size.width * 0.8, y: size.height * 0.1)
        button.delegate = self
        setUpUI()
    }
   
   override func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
      super.loginButtonDidLogOut(loginButton)
      user = FirebaseManager.manager.user
   }
    
    func setUpUI (){
        let backgroundColor = Theme.Colors.BackgroundColor.color
        recentTableView.backgroundColor = backgroundColor
        recentTableView.tableFooterView = UIView()
        topContainer.backgroundColor = backgroundColor
        recentTableView.rowHeight = 100
        // nameLabel.font = Theme.Fonts.NormalTypeFace.font
        // settingsButton.hidden = true
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithCellIdentifier(.ProfileCell) as! ProfileHeaderCell
        switch (indexPath.section, indexPath.row){
        case (0,0):
            if let user = user {
                cell.user = user
            }
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
