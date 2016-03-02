import UIKit

@objc protocol UserMessageCellDelegate {
    optional func userMessageCell(userMessageCell: UserMessageCell, didTapUser user: AnyObject)
}

class UserMessageCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    var user:User?
    
    weak var delegate: UserMessageCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        messageLabel.sizeToFit()
        messageLabel.numberOfLines = 0
        messageLabel.layoutIfNeeded()
        contentView.frame.size.height = messageLabel.frame.size.height + 10
        addTapGesture()
        backgroundColor = UIColor.clearColor()
        messageLabel.font = Theme.Fonts.NormalTypeFace.font
        messageLabel.textColor = UIColor.whiteColor()
    }
    
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: "onTapHandle")
        tapGesture.numberOfTapsRequired = 1
        profileImageView.userInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
    }
    
    func onTapHandle() {
        delegate?.userMessageCell!(self, didTapUser: user!)
    }
}