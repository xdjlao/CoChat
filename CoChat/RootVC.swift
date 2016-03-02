//
//  RootVC.swift
//  CoChat
//
//  Created by Aaron B on 2/29/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class RootVC: UIViewController {
    @IBOutlet var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "videoDidStopPlaying", name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
//        guard let url = NSBundle.mainBundle().URLForResource("LaunchVideo", withExtension: "mov") else {return}
//        let player = AVPlayer(URL:url)
//        let playerController = AVPlayerViewController()
//        playerController.player = player
//        let frame = CGRectMake(0, 0, container.frame.size.width, container.frame.size.width)
//        playerController.view.frame = frame
//        playerController.showsPlaybackControls = false
//        playerController.view.backgroundColor = Theme.Colors.NavigationBarColor.color
//        container.addSubview(playerController.view)
//
//        view.backgroundColor = Theme.Colors.NavigationBarColor.color
//            player.play()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        videoDidStopPlaying()
    }
    
    func videoDidStopPlaying(){
        let segueID = SegueIdentifier.SegueToTabBar
        performSegueWithSegueIdentifier(segueID, sender: self)
    }
}
