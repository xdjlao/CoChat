import UIKit

class WhisperCell: UITableViewCell {
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var contentWrapperView: UIView!
    @IBOutlet var imageSeparatorView: UIView!
    @IBOutlet var contentSeparatorView: UIView!
    @IBOutlet var container: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentWrapperView.backgroundColor = Theme.Colors.ForegroundColor.color
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.font = Theme.Fonts.NormalTypeFace.font
        messageLabel.textColor = UIColor.whiteColor()
        timestampLabel.textColor = UIColor.whiteColor()
    }
}
