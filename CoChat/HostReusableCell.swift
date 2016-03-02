import UIKit
@objc protocol HostReusableCellDelegate: class {
    func hostReusableCell(cell: HostReusableCell, valueDidChange: AnyObject?)
    optional func createNewChannel(sender:AnyObject?)
    optional func textFieldDidBeginEditingInCell(textField:UITextField)
    optional func textFieldDidEndEditingInCell()
}

enum HostCellType {
    case NameOfRoom
    case PasscodeOfRoom
    case EnableChannels
    case Privacy
    case None
}

var cellContent:[String: [String]] = [
    "basicContent":["Title"],
    
    "advancedContent":["Advanced Settings",
        "Room Entry Key",
        "Public",
        "Add Channels"]
]



class HostReusableCell: UITableViewCell, UITextFieldDelegate {
    override func awakeFromNib() {
        backgroundColor = Theme.Colors.ForegroundColor.color
        title.textColor = UIColor.whiteColor()
        title.font = Theme.Fonts.BoldNormalTypeFace.font
        addButton.tintColor = Theme.Colors.ButtonColor.color
        super.awakeFromNib()
    }
    
    var type = HostCellType.None
    var originalTextValue:String?
    var enteredPasscode = ""
    var enteredPrivacy:Bool?
    
    weak var delegate: HostReusableCellDelegate?
    
    @IBOutlet var addButton: UIButton!
    @IBOutlet var titleConstraintToLeftSuperView: NSLayoutConstraint!
    @IBOutlet var switchToggle: UISwitch!
    @IBOutlet var title: UITextField! {
        didSet {
            title.delegate = self
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        originalTextValue = textField.text
        textField.text = ""
        delegate?.textFieldDidBeginEditingInCell!(textField)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == ""  {
            textField.text = originalTextValue
        }
        delegate?.textFieldDidEndEditingInCell!()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let finalString = textField.text! + string
        delegate?.hostReusableCell(self, valueDidChange: finalString)
        return true
    }
    
    @IBAction func switchWasTapped(sender: UISwitch) {
        delegate?.hostReusableCell(self, valueDidChange: sender)
    }
    
    func setUpCellAtIndexPath(indexPath:NSIndexPath) {
        guard let basicContent = cellContent["basicContent"] else {return print("couldn't read basicContent")}
        guard let advancedContent = cellContent["advancedContent"] else {return print("couldn't read basicContent")}
        switch (indexPath.section, indexPath.row) {
        case (2,0):
            title.placeholder = basicContent[indexPath.row]
            title.text = ""
            type = .NameOfRoom
        case (3,0):
            title.text = advancedContent[indexPath.row]
            title.userInteractionEnabled = false
            addButton.hidden = false
            addButton.imageView?.image = UIImage(named: "downChevron")
            addButton.enabled = false
            setHeaderUI()
        case (3,1):
            title.placeholder = advancedContent[indexPath.row]
            title.text = enteredPasscode
            type = .PasscodeOfRoom
        case (3,2):
            title.text = advancedContent[indexPath.row]
            title.userInteractionEnabled = false
            type = .Privacy
            switchToggle.hidden = false
            if enteredPrivacy != nil {
                switchToggle.on = enteredPrivacy!
            }
            titleConstraintToLeftSuperView.constant = 55
        case (3,3):
            title.text = advancedContent[indexPath.row]
            title.userInteractionEnabled = false
            accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        default:
            assertionFailure()
        }
    }
    
    func setHeaderUI(){
        layer.shadowOffset = CGSizeMake(1, 0)
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 1.0
        backgroundColor = Theme.Colors.DarkBackgroundColor.color
        titleConstraintToLeftSuperView.constant = 10
    }

    func resetCellUI(){
        titleConstraintToLeftSuperView.constant = 55
        userInteractionEnabled = true
        title.textColor = UIColor.whiteColor()
        title.userInteractionEnabled = true
        backgroundColor = Theme.Colors.ForegroundColor.color
        layer.shadowOpacity = 0.0
        selectionStyle = .None
        accessoryType = UITableViewCellAccessoryType.None
        addButton.hidden = true
        switchToggle.hidden = true
        selectionStyle = .None
    }
}