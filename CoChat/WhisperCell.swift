import UIKit

class WhisperCell: UITableViewCell {
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var labelContainer: UIView!
    @IBOutlet var imageContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelContainer.backgroundColor = Theme.Colors.ForegroundColor.color
        imageContainer.backgroundColor = Theme.Colors.ForegroundColor.color
    }
}
