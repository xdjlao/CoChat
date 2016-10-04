import UIKit


class ProfileLogoutCell: UITableViewCell {
    
    @IBOutlet weak var logoutCellView: UIView!
    var superviewWidth:CGFloat!
    
    var loginButton: UIButton!
    


    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Theme.Colors.BackgroundColor.color
        
        loginButton = UIButton(type: .System)
        loginButton.setTitle("Login", forState: UIControlState())
        loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState())
        loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        loginButton.layer.borderWidth = 1
        loginButton.layer.cornerRadius = 1
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), forControlEvents: .TouchUpInside)
        
        logoutCellView.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(loginButton.leftAnchor.constraintEqualToAnchor(logoutCellView.leftAnchor))
        constraints.append(loginButton.rightAnchor.constraintEqualToAnchor(logoutCellView.rightAnchor))
        constraints.append(loginButton.topAnchor.constraintEqualToAnchor(logoutCellView.topAnchor))
        constraints.append(loginButton.bottomAnchor.constraintEqualToAnchor(logoutCellView.bottomAnchor))
        
        NSLayoutConstraint.activateConstraints(constraints)
        
    }
    
    var delegate: ProfileLogoutCellDelegate!
    func loginButtonTapped() {
        delegate.loginButtonTapped()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


protocol ProfileLogoutCellDelegate {
    func loginButtonTapped()
}
