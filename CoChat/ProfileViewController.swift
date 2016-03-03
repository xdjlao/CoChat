import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import AFNetworking

class ProfileViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    private var cellArray = [AnyObject]()
    private var loginButton:FBSDKLoginButton?
    private var imageScale = CGFloat(0)
    private var originalImageHeight:CGFloat?
    @IBOutlet var topContainer: UIView!
    @IBOutlet weak var recentTableView: UITableView! {
        didSet {
            recentTableView.delegate = self
            recentTableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton = createFBLoginButton()
        loginButton!.delegate = self
        setUpUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupArray()
        recentTableView.reloadData()
    }
    
    func setupArray() {
        cellArray = []
        cellArray.append("Header")
        var tempArray:[Channel] = []
        for fav: Channel in FirebaseManager.manager.user.favoriteChannels {
            tempArray.append(fav)
        }
        let reverseArray = NSArray(array: tempArray.reverse())
        cellArray.appendContentsOf(reverseArray)
        cellArray.append("Footer")
    }
    
    func setUpUI (){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        let backgroundColor = Theme.Colors.BackgroundColor.color
        recentTableView.backgroundColor = backgroundColor
        recentTableView.tableFooterView = UIView()
        topContainer.backgroundColor = backgroundColor
        recentTableView.separatorStyle = .None
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count // Add a profile header and profile logout cell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case(0,0):
            let cell = tableView.dequeueReusableCellWithCellIdentifier(.ProfileCell) as! ProfileHeaderCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            originalImageHeight = 100
            return cell
        case(0,cellArray.count - 1):
            let cell = tableView.dequeueReusableCellWithCellIdentifier(.ProfileLogoutCell) as! ProfileLogoutCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.superviewWidth = view.frame.width
            cell.profileLogoutButton = loginButton
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithCellIdentifier(.ProfileFavoriteCell) as! ProfileFavoriteCell
            let favoriteChannel = cellArray[indexPath.row] as! Channel
            cell.favoriteImageView.image = UIImage(named: "favoriteFilled")
            cell.favoriteChannelLabel.text = favoriteChannel.room.title
            cell.favoriteChannelLabelName.text =  favoriteChannel.title
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            if indexPath.row != cellArray.count - 2 {
                cell.imageSeparatorView.backgroundColor = Theme.Colors.ForegroundColor.color
                cell.contentSeparatorView.backgroundColor = Theme.Colors.DarkBackgroundColor.color
            } else {
                cell.imageSeparatorView.backgroundColor = Theme.Colors.BackgroundColor.color
                cell.contentSeparatorView.backgroundColor = Theme.Colors.BackgroundColor.color
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row){
        case(0,0):
            //Log Out here
            break
        case(0,cellArray.count - 1):
            break
        default:
            guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? ProfileFavoriteCell else {return}
            UIView.animateWithDuration(0.2, delay: 0.0, options: [], animations: { () -> Void in
                cell.favoriteContentWrapperView.backgroundColor = Theme.Colors.BackgroundColor.color
                }) { (Bool) -> Void in
                    cell.favoriteContentWrapperView.backgroundColor = Theme.Colors.ForegroundColor.color
                    let channel = self.cellArray[indexPath.row] as! Channel
                    self.performSegueWithSegueIdentifier(.ProfileToMessagingSegue, sender: channel)
            }
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.scrollEnabled = false
        } else {
            scrollView.scrollEnabled = true
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            if let cell = recentTableView.cellForRowAtIndexPath(indexPath) as? ProfileHeaderCell {
                if scrollView.contentOffset.y <= 80 {
                    let centerPoint = cell.userImageView.center
                    if cell.userImageView.frame.height >= 20 && cell.userImageView.frame.height <= originalImageHeight {
                        let newImageScale = scrollView.contentOffset.y - imageScale
                        imageScale = imageScale + newImageScale
                        let imageHeight = cell.userImageView.frame.height
                        cell.userImageView.frame = CGRect(x: 0, y: 0, width: imageHeight - newImageScale, height: imageHeight - newImageScale)
                        cell.userImageView.center = CGPointMake(centerPoint.x, centerPoint.y + newImageScale/1.5)
                        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.width / 2
                    }
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case(0,0): return 200
        case(0,cellArray.count - 1): return 80
        default: return 71
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as! MessagingNavigationViewController
        let mvc = destination.topViewController as! MessagingViewController
        let channel = sender as! Channel
        let room = channel.room
        mvc.room = room
    }
}