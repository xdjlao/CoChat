//
//  ProfileFavoriteCell.swift
//  CoChat
//
//  Created by Jerry on 3/2/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit

class ProfileFavoriteCell: UITableViewCell {

    @IBOutlet var favoriteImageView: UIImageView!
    @IBOutlet var favoriteChannelLabel: UILabel!
    @IBOutlet var imageWrapperView: UIView!
    @IBOutlet var favoriteContentWrapperView: UIView!
    @IBOutlet var imageSeparatorView: UIView!
    @IBOutlet var contentSeparatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageWrapperView.backgroundColor = Theme.Colors.DarkBackgroundColor.color
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        favoriteChannelLabel.font = Theme.Fonts.NormalTypeFace.font
        favoriteChannelLabel.textColor = UIColor.whiteColor()
        favoriteContentWrapperView.backgroundColor = Theme.Colors.ForegroundColor.color
    }

}
