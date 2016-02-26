//
//  AddNewChannelCell.swift
//  CoChat
//
//  Created by Aaron B on 2/24/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
protocol ChannelHeaderCellDelegate : class{
    func addNewChannel(sender: AnyObject?)
    func createChannel(sender: AnyObject?)
}


class ChannelHeaderCell: UITableViewCell {
    weak var delegate: ChannelHeaderCellDelegate?
    @IBOutlet var addButton: UIButton!
    @IBOutlet var createButton: UIButton!
    @IBOutlet var headerTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func addNewChannelWasTapped(sender: UIButton) {
      delegate?.addNewChannel(sender)
        print("addNewChannelTappedinxxib")
    }
    
    @IBAction func createChannelWasTapped(sender: UIButton) {
        delegate?.createChannel(sender)
        print("createNewChannelTappedinXib")

    }
}
