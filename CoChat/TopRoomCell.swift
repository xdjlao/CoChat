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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
