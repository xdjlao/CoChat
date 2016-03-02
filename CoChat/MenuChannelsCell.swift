//
//  MenuChannelsCell.swift
//  CoChat
//
//  Created by Aaron B on 3/1/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
protocol MenuChannelsCellDelegate: class {
    func addFavorite(channelName:String)
    func removeFavorite(channelName:String)
}

class MenuChannelsCell: UITableViewCell {
    weak var delegate: MenuChannelsCellDelegate?
    var isFavorite = false
    
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
        favoriteButton.setImage(UIImage(named: "favorite"), forState: .Normal)
    }
    
    @IBAction func favoriteButtonWasTapped(sender: UIButton) {
        guard let channelName = channelsLabel?.text else{return}
        switch isFavorite {
        case false:
            favoriteButton.setImage(UIImage(named: "favoriteFilled"), forState: .Normal)
            isFavorite = !isFavorite
            delegate?.addFavorite(channelName)
            return
        case true:
            favoriteButton.setImage(UIImage(named: "favorite"), forState: .Normal)
            isFavorite = !isFavorite
            delegate?.removeFavorite(channelName)
            return
        }
    }
}
