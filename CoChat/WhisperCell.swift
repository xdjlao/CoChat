//
//  WhisperCell.swift
//  CoChat
//
//  Created by Aaron B on 2/28/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

class WhisperCell: UITableViewCell {
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var timestampLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
