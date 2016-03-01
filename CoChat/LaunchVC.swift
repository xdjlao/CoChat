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
@IBOutlet var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = Theme.Colors.NavigationBarColor.color
        playVideo()
    }
    
    func playVideo() {
        guard let path = NSBundle.mainBundle().pathForResource("launch", ofType:"mp4") else {return}
        let player = AVPlayer(URL: NSURL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        view.addSubview(playerController.view)
        view.bringSubviewToFront(playerController.view)
        player.play()
    }
    
    
    }
