//
//  HeaderCell.swift
//  hostProject
//
//  Created by Aaron B on 2/21/16.
//  Copyright © 2016 Bikis Design. All rights reserved.
//

import UIKit
protocol HostReusableCellDelegate: class {
    func hostReusableCell(cell: HostReusableCell, valueDidChange: AnyObject?)
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
    
    weak var cellDelegate:HostReusableCellDelegate?
    
    @IBOutlet var icon: UIImageView!
    @IBOutlet var title: UITextField!
    @IBOutlet var switchToggle: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        title.delegate = self
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        originalTextValue = textField.text
        textField.text = ""
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text != originalTextValue {
        textField.resignFirstResponder()
        cellDelegate?.hostReusableCell(self, valueDidChange: textField.text)
        }
        else {
            textField.text = originalTextValue
        }
    }
    
    @IBAction func switchWasTapped(sender: UISwitch) {
        cellDelegate?.hostReusableCell(self, valueDidChange: sender)
    }
}
