import UIKit

class GeneralMessageCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //makes profile picture round
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        messageLabel.sizeToFit()
        messageLabel.numberOfLines = 0
        messageLabel.layoutIfNeeded()
    }
}
