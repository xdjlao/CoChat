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
}

enum HostCellType {
    case NameOfRoom
    case DescriptionOfRoom
    case PasscodeOfRoom
    case EnableChannels
    case Privacy
    case None
}


class HostReusableCell: UITableViewCell, UITextFieldDelegate {
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
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == ""  {
            textField.text = originalTextValue
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        guard textField.text != originalTextValue else { return true }
//        let newRange = Range(start: string.startIndex, end: string.endIndex)
//        let nameOfRoom = textField.text?.stringByReplacingCharactersInRange(newRange, withString: string)
//        delegate?.hostReusableCell(self, valueDidChange: nameOfRoom)
//
        print("string :")
        print(string)
        print("textfieldtxt :")
        print(textField.text)
        
        let finalString = textField.text! + string
        delegate?.hostReusableCell(self, valueDidChange: finalString)
        print(finalString)
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
        switchToggle.hidden = true
        selectionStyle = .None
        accessoryType = UITableViewCellAccessoryType.None
        title.userInteractionEnabled = true
        
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            icon.image = UIImage(named: "Create")
            title.text = basicContent![indexPath.row]
            userInteractionEnabled = false
        case (1,0):
            icon.image = UIImage(named: "Settings")
            title.text = advancedContent![indexPath.row]
            title.userInteractionEnabled = false
            selectionStyle = .Gray
        case (0,1):
            title.text = basicContent![indexPath.row]
            type = .NameOfRoom
        case (0,2):
            title.text = basicContent![indexPath.row]
            type = .DescriptionOfRoom
        case (1,1):
            title.text = advancedContent![indexPath.row]
            type = .PasscodeOfRoom
        case (1,2):
            title.text = advancedContent![indexPath.row]
            title.userInteractionEnabled = false
            type = .Privacy
            switchToggle.hidden = false
        case (1,3):
            title.text = advancedContent![indexPath.row]
            title.userInteractionEnabled = false
            accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            selectionStyle = .Gray
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
