import UIKit

@objc protocol MenuChannelViewControllerDelegate {
    optional func menuChannelViewController(menuChannelViewController: MenuChannelViewController, didSelectChannel channel: AnyObject)
}

class MenuChannelViewController: UIViewController, MenuChannelsCellDelegate {
    @IBOutlet var tableView: UITableView!
    
    var channels: [Channel]!
    var room:Room?
    
    weak var delegate: MenuChannelViewControllerDelegate?
    
    override func viewDidLoad() {
        setUpUI()
    }
    
    func setUpUI(){
    navigationItem.title = "Channels"
    let addChannelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addChannel")
    navigationItem.rightBarButtonItem = addChannelButton
    view.backgroundColor = Theme.Colors.BackgroundColor.color
    tableView.backgroundColor = Theme.Colors.BackgroundColor.color
    tableView.separatorInset = UIEdgeInsetsZero
    tableView.tableFooterView = UIView()
    }
    
    func addFavorite(channelName: String) {
        //query for channel UID and add to user here
    }
    func removeFavorite(channelName: String) {
        //same same
    }
}

extension MenuChannelViewController : UITableViewDataSource, UITableViewDelegate  {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithCellIdentifier(UITableView.CellIdentifier.MenuChannelsCell) as! MenuChannelsCell
        cell.channelsLabel?.text = channels[indexPath.row].title
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let channel = channels[indexPath.row]
        self.delegate?.menuChannelViewController!(self, didSelectChannel: channel)
        navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66
    }
    
    func addChannel() {
        performSegueWithSegueIdentifier(SegueIdentifier.SegueToChannelsVC, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.SegueToChannelsVC.rawValue {
            guard let cvc = segue.destinationViewController as? ChannelsVC else {return}
            cvc.room = room
        }
    }
}