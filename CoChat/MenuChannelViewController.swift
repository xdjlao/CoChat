import UIKit

@objc protocol MenuChannelViewControllerDelegate {
    optional func menuChannelViewController(menuChannelViewController: MenuChannelViewController, didSelectChannel channel: AnyObject)
}

class MenuChannelViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var channels: [Channel]!
    
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
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        launchAlertController(indexPath)
    }
    
    func launchAlertController(indexPath:NSIndexPath){
        let channel = channels[indexPath.row]
        
        let channelDescriptionAlertController = UIAlertController(title: channel.title, message: "\(channel.subtitle)\nPassCode:\(channel.password)" , preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        let goToChannel = UIAlertAction(title: "Go To Channel", style: UIAlertActionStyle.Destructive) {
            (UIAlertAction) -> Void in
            self.delegate?.menuChannelViewController!(self, didSelectChannel: channel)
            self.navigationController?.popViewControllerAnimated(true)
        }
        channelDescriptionAlertController.addAction(cancel)
        channelDescriptionAlertController.addAction(goToChannel)
        presentViewController(channelDescriptionAlertController, animated: true, completion: nil)
    }
    
    func addChannel() {
        print("Channel added")
    }
}