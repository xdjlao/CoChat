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
    optional func addNewChannel(sender:AnyObject?)
    optional func createNewChannel(sender:AnyObject?)
    optional func textFieldDidBeginEditingInCell(textField:UITextField)
    optional func textFieldDidEndEditingInCell()
    optional func animateTextField(textField:UITextField)
}

enum HostCellType {
    case NameOfRoom
    case PasscodeOfRoom
    case EnableChannels
    case Privacy
    case None
}

var cellContent:[String: [String]] = [
    "basicContent":["Name Of Room"],
    
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
    
    weak var delegate: HostReusableCellDelegate?
    
    @IBOutlet var addButton: UIButton!
    @IBOutlet var titleConstraintToLeftSuperView: NSLayoutConstraint!
    @IBOutlet var switchToggle: UISwitch!
    @IBOutlet var createButton: UIButton!
    @IBOutlet var title: UITextField! {
        didSet {
            title.delegate = self
        }
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        originalTextValue = textField.text
        textField.text = ""
        delegate?.textFieldDidBeginEditingInCell!(textField)
//        delegate?.animateTextField!(textField)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == ""  {
            textField.text = originalTextValue
            textField.alpha = 0.5
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
        resetCellUI()
        switch (indexPath.section, indexPath.row) {
        case (2,0):
            title.text = basicContent[indexPath.row]
            title.alpha = 0.5
            type = .NameOfRoom
        case (3,0):
            title.text = advancedContent[indexPath.row]
            title.userInteractionEnabled = false
            addButton.hidden = false
            addButton.imageView?.image = UIImage(named: "downChevron")
            addButton.alpha = 1.0
            addButton.enabled = false
        case (3,1):
            title.text = advancedContent[indexPath.row]
            title.alpha = 0.5
            type = .PasscodeOfRoom
        case (3,2):
            title.text = advancedContent[indexPath.row]
            title.userInteractionEnabled = false
            title.alpha = 1.0
            type = .Privacy
            switchToggle.hidden = false
        case (3,3):
            title.text = advancedContent[indexPath.row]
            title.userInteractionEnabled = false
            accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        default:
            assertionFailure()
        }
    }
    
    func resetCellUI(){
        userInteractionEnabled = true
        title.userInteractionEnabled = true
        selectionStyle = .None
        accessoryType = UITableViewCellAccessoryType.None
        addButton.hidden = true
        switchToggle.hidden = true
        createButton.hidden = true
        selectionStyle = .None
    }
    
    @IBAction func addWasTapped(sender: UIButton) {
        delegate?.addNewChannel?(sender)
    }
    
    @IBAction func createWasTapped(sender: UIButton) {
        delegate?.createNewChannel?(sender)
    }
    
}