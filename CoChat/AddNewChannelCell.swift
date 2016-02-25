//
//  AddNewChannelCell.swift
//  CoChat
//
//  Created by Aaron B on 2/24/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
protocol AddNewChannelCellDelegate : class{
    func addNewChannel(sender: AnyObject?)
    func createChannel(sender: AnyObject?)
}


class AddNewChannelCell: UITableViewCell {
    weak var delegate: AddNewChannelCellDelegate?
    @IBOutlet var addNewChannelLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var createButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func addNewChannelWasTapped(sender: UIButton) {
      delegate?.addNewChannel(sender)
    }
    @IBAction func createChannelWasTapped(sender: UIButton) {
        delegate?.createChannel(sender)
    }
}
