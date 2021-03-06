import UIKit

@objc protocol GeneralMessageCellDelegate {
    optional func generalMessageCell(generalMessageCell: GeneralMessageCell, didTapUser user: AnyObject)
}

class GeneralMessageCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    var user:User?
    
    weak var delegate: GeneralMessageCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //makes profile picture round
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        messageLabel.sizeToFit()
        messageLabel.textColor = UIColor.whiteColor()
        self.backgroundColor = Theme.Colors.BackgroundColor.color
        messageLabel.font = Theme.Fonts.NormalTypeFace.font
        messageLabel.numberOfLines = 0
        messageLabel.layoutIfNeeded()
        addTapGesture()
    }
    
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GeneralMessageCell.onTapHandle))
        tapGesture.numberOfTapsRequired = 1
        profileImageView.userInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
    }
    
    func onTapHandle() {
        delegate?.generalMessageCell!(self, didTapUser: user!)
    }
}
