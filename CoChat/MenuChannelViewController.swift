import UIKit

@objc protocol MenuChannelViewControllerDelegate {
    optional func menuChannelViewController(menuChannelViewController: MenuChannelViewController, didSelectChannel channel: AnyObject)
}

class MenuChannelViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var channels: [Channel]!
    var room:Room?
    
    weak var delegate: MenuChannelViewControllerDelegate?
    
    override func viewDidLoad() {
        setUpUI()
    }
    
    func setUpUI(){
        navigationItem.title = "Channels"
        let addChannelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(MenuChannelViewController.addChannel))
        navigationItem.rightBarButtonItem = addChannelButton
        view.backgroundColor = Theme.Colors.BackgroundColor.color
        tableView.backgroundColor = Theme.Colors.BackgroundColor.color
        navigationController?.navigationBar.tintColor = Theme.Colors.ButtonColor.color
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.tableFooterView = UIView()
        //disable add channel icon
        navigationItem.rightBarButtonItem?.tintColor = UIColor.clearColor()
        navigationItem.rightBarButtonItem?.enabled = false
    }
    
}

extension MenuChannelViewController: MenuChannelsCellDelegate {
    func channelFavoritingChanged(channel: Channel, isFavorite: Bool) {
        let user = FirebaseManager.manager.user
        
        switch isFavorite {
        case true:
            user.favoriteChannels.append(channel)
            user.saveSelf()
        case false:
            let index = user.favoriteChannels.indexOf { testChannel -> Bool in
                return channel.uid == testChannel.uid
            }
            user.favoriteChannels.removeAtIndex(index!)
            user.saveSelf()
        }
    }
}

extension MenuChannelViewController : UITableViewDataSource, UITableViewDelegate  {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithCellIdentifier(UITableView.CellIdentifier.MenuChannelsCell) as! MenuChannelsCell
        cell.channel = channels[indexPath.row]
        cell.channelsLabel?.text = cell.channel.title
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