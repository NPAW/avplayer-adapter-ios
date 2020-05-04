//
//  ViewController.swift
//  AvPlayerAdapterExample-tvOS
//
//  Created by nice on 16/12/2019.
//  Copyright © 2019 npaw. All rights reserved.
//

import UIKit
import AVKit

class PlayerViewController: UIViewController {
    var playerViewController: AVPlayerViewController?
    
    var viewModel: AvPlayerExampleViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,selector: #selector(self.appWillResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object:nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.appDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive , object:nil)
        
        self.initializePlayer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.viewModel?.stopYoubora()
    }
    
    @objc func appWillResignActive(notification: NSNotification){
       self.viewModel?.stopYoubora()
    }
    
    @objc func appDidBecomeActive(notification: NSNotification){
        self.viewModel?.startYoubora(with: self.playerViewController?.player)
    }
}

// MARK: - Video Player methods
extension PlayerViewController {
    private func initializePlayer() {
        guard let viewModel = self.viewModel,
            let resourceUrl = viewModel.getVideoUrl() else {
                return
        }
        
        // Video player controller
        self.playerViewController = AVPlayerViewController()
        
        // Add view to the current screen
        self.addChildViewController(playerViewController!)
        self.view.addSubview((self.playerViewController?.view)!)
        
        // We use the playerView view as a guide for the video
        self.playerViewController?.view.frame = self.view.frame
        
        // Create AVPlayer
        self.playerViewController?.player = AVPlayer(url: resourceUrl)
        
        viewModel.startYoubora(with: self.playerViewController?.player)
        
        // Start playback
        playerViewController?.player?.play()
    }
}


