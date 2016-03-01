//
//  LaunchVC.swift
//  CoChat
//
//  Created by Aaron B on 2/29/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit
import AVFoundation

class LaunchVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Colors.NavigationBarColor.color
        
        let myPlayerView = UIView(frame: self.view.bounds)
        view.addSubview(myPlayerView)
   
        guard let path = NSBundle.mainBundle().pathForResource("Launch", ofType: "mp4") else {return}
        let url = NSURL(fileURLWithPath: path)
        let player = AVPlayer(URL: url)
        let playerController = AVPlayerViewController()
        playerController.player = player
        player.play()
        
        let avLayer = AVPlayerLayer(player: player)
        avLayer.frame = myPlayerView.bounds
        myPlayerView.layer.addSublayer(avLayer)
    
    }
}
