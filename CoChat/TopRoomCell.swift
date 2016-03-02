//
//  TopRoomCell.swift
//  CoChat
//
//  Created by Jerry on 2/26/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

class TopRoomCell: UITableViewCell {

    @IBOutlet weak var cellCountWrapperView: UIView!
    @IBOutlet weak var cellWrapperView: UIView!
    @IBOutlet weak var roomTitleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet var countCellSeperator: UIView!
    @IBOutlet var cellSeperator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        countLabel.font = Theme.Fonts.BoldTitleTypeFace.font
        roomTitleLabel.font = Theme.Fonts.NormalTypeFace.font
        roomTitleLabel.textColor = UIColor.whiteColor()
        cellCountWrapperView.backgroundColor = Theme.Colors.DarkBackgroundColor.color
        cellWrapperView.backgroundColor = Theme.Colors.ForegroundColor.color
        countCellSeperator.backgroundColor = Theme.Colors.ForegroundColor.color
        cellSeperator.backgroundColor = Theme.Colors.DarkBackgroundColor.color
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
