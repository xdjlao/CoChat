import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import AFNetworking

class ProfileViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    private var cellArray = [AnyObject]()
    private var loginButton:FBSDKLoginButton?
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
        setupArray()
        setUpUI()
    }
    
    func setupArray() {
        
    }
    
    func setUpUI (){
        let backgroundColor = Theme.Colors.BackgroundColor.color
        recentTableView.backgroundColor = backgroundColor
        recentTableView.tableFooterView = UIView()
        topContainer.backgroundColor = backgroundColor
        recentTableView.separatorStyle = .None
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count + 2 // Add a profile header and profile logout cell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case(0,0):
            let cell = tableView.dequeueReusableCellWithCellIdentifier(.ProfileCell) as! ProfileHeaderCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        case(0,cellArray.count + 1):
            let cell = tableView.dequeueReusableCellWithCellIdentifier(.ProfileLogoutCell) as! ProfileLogoutCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.superviewWidth = view.frame.width
            cell.profileLogoutButton = loginButton
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithCellIdentifier(.ProfileCell) as! ProfileHeaderCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
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
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.scrollEnabled = false
        } else {
            scrollView.scrollEnabled = true
            recentTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case(0,0): return 200
        case(0,cellArray.count + 1): return 80
        default: return tableView.rowHeight
        }
    }
}