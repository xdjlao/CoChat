import UIKit

class UserMessageCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        messageLabel.sizeToFit()
        messageLabel.numberOfLines = 0
        messageLabel.layoutIfNeeded()
        contentView.frame.size.height = messageLabel.frame.size.height + 10
    }
}