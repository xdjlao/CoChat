//
//  LaunchVC.swift
//  CoChat
//
//  Created by Aaron B on 2/29/16.
//  Copyright © 2016 Jerry. All rights reserved.
//

import UIKit
import MediaPlayer

class LaunchVC: UIViewController {
    @IBOutlet var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "MoviePlayerStopedPlaying:", name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
        containerView.backgroundColor = Theme.Colors.NavigationBarColor.color
        
    }
    func queueLaunchVideo(){
        
        guard let filePath: String = NSBundle.mainBundle().pathForResource("launch", ofType: "mp4") else { return}
     let videoUrl = NSURL(fileURLWithPath: filePath)
     let mediaPlayer = MPMoviePlayerController(contentURL: videoUrl)
    mediaPlayer.shouldAutoplay = true
    mediaPlayer.movieSourceType = MPMovieSourceType.File
    mediaPlayer.view.frame = containerView.frame
    containerView.addSubview(mediaPlayer.view)
    mediaPlayer.prepareToPlay()
    mediaPlayer.play()
    }
}
