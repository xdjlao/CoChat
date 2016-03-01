import UIKit

class WhisperViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
 var whispers = [Whisper]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = Theme.Colors.BackgroundColor.color
    }
    
}

extension WhisperViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WhisperCell", forIndexPath: indexPath) as! WhisperCell
        cell.nameLabel.text = whispers[indexPath.row].sender.name
        cell.messageLabel.text = whispers[indexPath.row].text
        cell.profileImageView.image = UIImage(named: "dummyImage")
        return cell
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return whispers.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}