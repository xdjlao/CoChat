import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import AFNetworking

class ProfileViewController: UIViewController, FBSDKLoginButtonDelegate {
   
   @IBOutlet var topContainer: UIView!
   @IBOutlet weak var recentTableView: UITableView! {
      didSet {
      recentTableView.delegate = self
      recentTableView.dataSource = self
      }
   }

   override func viewDidLoad() {
      super.viewDidLoad()
      let size = view.frame.size
      let button = createFBLoginButtonWithPosition(size.width * 0.8, y: size.height * 0.1)
      button.delegate = self
      setUpUI()
   }

   func setUpUI (){
      let backgroundColor = Theme.Colors.BackgroundColor.color
      recentTableView.backgroundColor = backgroundColor
      recentTableView.tableFooterView = UIView()
      topContainer.backgroundColor = backgroundColor
      recentTableView.rowHeight = 200
      recentTableView.separatorStyle = .None
   }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 1
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithCellIdentifier(.ProfileCell) as! ProfileHeaderCell
      cell.selectionStyle = UITableViewCellSelectionStyle.None
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
   func scrollViewDidScroll(scrollView: UIScrollView) {
      if scrollView.contentOffset.y < 0 {
         scrollView.scrollEnabled = false
      } else {
         scrollView.scrollEnabled = true
      }
   }
}