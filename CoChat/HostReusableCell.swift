//
//  HeaderCell.swift
//  hostProject
//
//  Created by Aaron B on 2/21/16.
//  Copyright © 2016 Bikis Design. All rights reserved.
//

import UIKit
@objc protocol HostReusableCellDelegate: class {
    func hostReusableCell(cell: HostReusableCell, valueDidChange: AnyObject?)
    optional func addAnotherChannel(sender:AnyObject?)
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


class HostReusableCell: UITableViewCell, UITextFieldDelegate {
    override func awakeFromNib() {
        backgroundColor = Theme.Colors.ForegroundColor.color
        title.textColor = UIColor.whiteColor()
        title.font = Theme.Fonts.BoldNormalTypeFace.font
        icon.tintColor = Theme.Colors.ButtonColor.color
        addButton.tintColor = Theme.Colors.ButtonColor.color
        super.awakeFromNib()
    }
    
    var type = HostCellType.None
    var originalTextValue:String?
    
    weak var delegate: HostReusableCellDelegate?
    
    @IBOutlet var addButton: UIButton!
    @IBOutlet var titleConstraintToLeftSuperView: NSLayoutConstraint!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var title: UITextField! {
        didSet {
            title.delegate = self
        }
    }
    @IBOutlet var switchToggle: UISwitch!
    
    
    
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
    
    func setUpCellAtIndexPath(indexPath:NSIndexPath, cellContent:[String: [String]]?) {
        let basicContent = cellContent?["basicContent"]
        let advancedContent = cellContent?["advancedContent"]
        
        icon.image = nil
        userInteractionEnabled = true
        title.userInteractionEnabled = true
        addButton.hidden = true
        switchToggle.hidden = true
        selectionStyle = .None
        accessoryType = UITableViewCellAccessoryType.None
        
        switch (indexPath.section, indexPath.row) {
        case (0,0)://Create a Room
            titleConstraintToLeftSuperView.constant = 10
            title.text = basicContent![indexPath.row]
            userInteractionEnabled = false
        case (1,0)://Advanced Settings
            title.text = advancedContent![indexPath.row]
            title.userInteractionEnabled = false
            addButton.hidden = false
            addButton.imageView?.image = UIImage(named: "downChevron")
            addButton.enabled = false
        case (0,1):
            title.text = basicContent![indexPath.row]
            title.alpha = 0.5
            type = .NameOfRoom
        case (1,1):
            title.text = advancedContent![indexPath.row]
            title.alpha = 0.5
            type = .PasscodeOfRoom
        case (1,2):
            title.text = advancedContent![indexPath.row]
            title.userInteractionEnabled = false
            type = .Privacy
            switchToggle.hidden = false
            switchToggle.onTintColor = Theme.Colors.ButtonColor.color
        case (1,3):
            title.text = advancedContent![indexPath.row]
            title.userInteractionEnabled = false
            userInteractionEnabled = true
            accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        case (2,0):
            title.text = "Add Another Channel"
            title.userInteractionEnabled = false
            titleConstraintToLeftSuperView.constant = 10
            addButton.hidden = false
            userInteractionEnabled = true
        default:
            assertionFailure()
        }
    }
    
    @IBAction func addButtonTapped(sender: UIButton) {
        delegate?.addAnotherChannel!(sender)
    }
    
}