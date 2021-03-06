//
//  MenuChannelsCell.swift
//  CoChat
//
//  Created by Aaron B on 3/1/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
protocol MenuChannelsCellDelegate: class {
    func channelFavoritingChanged(channel: Channel, isFavorite: Bool)
}

class MenuChannelsCell: UITableViewCell {
    weak var delegate: MenuChannelsCellDelegate?
    var isFavorite = false
    
    var channel: Channel! {
        didSet {
            if FirebaseManager.manager.user.favoriteChannels.contains( { checkChannel -> Bool in
                return checkChannel.uid == channel.uid
            }) {
                isFavorite = true
                setFavoriteButton()
            } else {
                isFavorite = false
                setFavoriteButton()
            }
        }
    }
    
    @IBOutlet var buttonContainer: UIView!
    @IBOutlet var channelsContainer: UIView!
    @IBOutlet var channelsLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    func setUpUI(){
        buttonContainer.backgroundColor = Theme.Colors.ForegroundColor.color
        channelsContainer.backgroundColor = Theme.Colors.ForegroundColor.color
        backgroundColor = Theme.Colors.ForegroundColor.color
        channelsLabel.textColor = UIColor.whiteColor()
        //setFavoriteButton()
    }
    
    @IBAction func favoriteButtonWasTapped(sender: UIButton) {
        isFavorite = !isFavorite
        delegate?.channelFavoritingChanged(channel, isFavorite: isFavorite)
        setFavoriteButton()
    }

    func setFavoriteButton(){
        switch isFavorite {
        case true:
            favoriteButton.setImage(UIImage(named: "favoriteFilled"), forState: .Normal)
        case false:
            favoriteButton.setImage(UIImage(named: "favorite"), forState: .Normal)
        }
    }
}
