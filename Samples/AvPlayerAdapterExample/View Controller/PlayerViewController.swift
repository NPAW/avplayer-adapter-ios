//
//  ViewController.swift
//  AvPlayerAdapterExample
//
//  Created by nice on 16/12/2019.
//  Copyright © 2019 npaw. All rights reserved.
//

import UIKit
import AVKit

class PlayerViewController: UIViewController {
    
    var viewModel: AvPlayerExampleViewModel?
    
    var playerViewController:AVPlayerViewController?
    
    var adsPlayerViewController:AVPlayerViewController?
    var adsTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,selector: #selector(self.appWillResignActive), name: UIApplication.willResignActiveNotification, object:nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object:nil)
        
        // Initialize player on this view controller
        self.initializePlayer()
        self.initializeAds()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel?.stopYoubora()
        guard let adsTimer = adsTimer else {
            return
        }
        
        adsTimer.invalidate()
        self.adsTimer = nil
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
        self.addChild(playerViewController!)
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

// MARK: - Ads Methods
extension PlayerViewController {
    func initializeAds() {
        guard let viewModel = self.viewModel else {
            return
        }
        
        if viewModel.containAds() {
            self.adsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkAdsToBePlayed), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func checkAdsToBePlayed() {
        guard let viewModel = self.viewModel,
            let playhead = self.playerViewController?.player?.currentTime(),
            let nextAd = viewModel.getNextAd(CMTimeGetSeconds(playhead)) else {
                return
        }
        
        self.playerViewController?.player?.pause()
        
        // Video player controller
        self.adsPlayerViewController = AVPlayerViewController()
        
        // Add view to the current screen
        self.addChild(adsPlayerViewController!)
        self.view.addSubview((self.adsPlayerViewController?.view)!)
        
        // We use the playerView view as a guide for the video
        self.adsPlayerViewController?.view.frame = self.view.frame
        
        // Create AVPlayer
        self.adsPlayerViewController?.player = AVPlayer(url: nextAd)
        
        viewModel.setAdsAdapterWith(self.adsPlayerViewController?.player)
        
        NotificationCenter.default.addObserver(self, selector: #selector(adDidFinish), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        // Start playback
        adsPlayerViewController?.player?.play()
    }
    
    @objc func adDidFinish() {
        guard let viewModel = self.viewModel else {
                return
        }
        
        self.adsPlayerViewController?.view.removeFromSuperview()
        self.adsPlayerViewController?.removeFromParent()
        self.adsPlayerViewController = nil
        
        self.playerViewController?.player?.play()
        
        viewModel.adsDidFinish()
    }
}

