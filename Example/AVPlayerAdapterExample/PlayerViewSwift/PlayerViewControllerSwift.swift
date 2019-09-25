//
//  PlayerViewController-Swift.swift
//  AVPlayerAdapterExample
//
//  Created by Enrique Alfonso Burillo on 05/01/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

import UIKit
import YouboraAVPlayerAdapter
import YouboraConfigUtils
import AVKit

class PlayerViewControllerSwift: UIViewController {
    
    @objc public var viewModel: PlayerViewModelSwift?
    
    var playerViewController:AVPlayerViewController? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.hidesBarsOnTap = true
        
        // Initialize player on this view controller
        self.initializePlayer()
        
        // As soon as we have the player instance, create an Adapter to listen for the player events and create a new view in Youbora
        self.viewModel?.startYoubora(player: self.playerViewController?.player)
        
        // Start playback
        playerViewController?.player?.play()
        
        // Uncomment this to test changing the rate
        //playerViewController?.player?.rate = 1.5;
    }
    
    private func initializePlayer() {
        // Video player controller
        self.playerViewController = AVPlayerViewController()
        
        // Add view to the current screen
        self.addChild(playerViewController!)
        self.view.addSubview((self.playerViewController?.view)!)
        
        // We use the playerView view as a guide for the video
        self.playerViewController?.view.frame = self.view.frame
        
        // Create AVPlayer
        self.playerViewController?.player = AVPlayer(url: self.viewModel!.videoUrl as URL)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel?.stopYoubora()
    }
    
}
