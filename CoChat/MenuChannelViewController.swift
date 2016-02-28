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
        navigationItem.title = "Channels"
        let addChannelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addChannel")
        navigationItem.rightBarButtonItem = addChannelButton
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
}

extension MenuChannelViewController : UITableViewDataSource, UITableViewDelegate  {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuChannelCell", forIndexPath: indexPath)
        cell.textLabel?.text = channels[indexPath.row].title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let channel = channels[indexPath.row]
        self.delegate?.menuChannelViewController!(self, didSelectChannel: channel)
        navigationController?.popViewControllerAnimated(true)
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