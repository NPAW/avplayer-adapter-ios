//
//  PlayerViewController.swift
//  AVPlayerSample
//
//  Created by Tiago Pereira on 01/09/2020.
//  Copyright © 2020 NicePeopleAtWork. All rights reserved.
//

import UIKit
import AVKit
import YouboraLib
import YouboraConfigUtils
import YouboraAVPlayerAdapter

class PlayerViewController: UIViewController {
    var resource: String?
    var containAds: Bool?
    
    var playerViewController:AVPlayerViewController?
    
    var adsPlayerViewController:AVPlayerViewController?
    var adsTimer: Timer?
    
    var changeItemButton = UIButton(type: .custom)
    var buttonReplay = UIButton(type: .custom)
    var playerContainer = UIView()
    
    var plugin: YBPlugin?
    
    private var adsInterval: [Int] {
        guard let containAds = self.containAds else { return  [] }
        
        if containAds { return [10,20,30] }
        
        return []
    }
    
    var currentAdPosition = 0
    var currentAdLink: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let options = YouboraConfigManager.getOptions()

        options.contentIsLive = NSNumber(value: resource == Resource.live || resource == Resource.liveAirShow)
        options.contentResource = self.resource
        
        self.plugin = YBPlugin(options: options)
        
        changeItemButton.setTitle("Change Item", for: .normal)
        
        changeItemButton.addTarget(self, action: #selector(changeItem), for:.touchUpInside)
        changeItemButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(changeItemButton)
        NSLayoutConstraint.activate([
            changeItemButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
            changeItemButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            changeItemButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            changeItemButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        buttonReplay.setTitle("Replay", for: .normal)
        buttonReplay.addTarget(self, action: #selector(pressToReply), for:.touchUpInside)
        buttonReplay.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(buttonReplay)
        NSLayoutConstraint.activate([
            buttonReplay.topAnchor.constraint(equalTo: changeItemButton.bottomAnchor, constant: 20),
            buttonReplay.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            buttonReplay.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            buttonReplay.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        playerContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerContainer)
        NSLayoutConstraint.activate([
            playerContainer.topAnchor.constraint(equalTo: buttonReplay.bottomAnchor, constant: 0),
            playerContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            playerContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            playerContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
        
        // Initialize player on this view controller
        self.initializePlayer()
        self.initializeAds()
    }
    
    
    @objc func changeItem() {
        guard let newResource = [
            Resource.hlsApple,
            Resource.hlsTest
        ].randomElement(), let url = URL(string: newResource) else {
            return
        }
        self.plugin?.options.contentIsLive = NSNumber(false)
        self.playerViewController?.player?.replaceCurrentItem(with: AVPlayerItem(url: url))
    }
    
    @objc func pressToReply() {
        self.playerViewController?.player?.seek(to: .zero)
        self.playerViewController?.player?.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let adsTimer = adsTimer {
            adsTimer.invalidate()
            self.adsTimer = nil
        }
        
        if self.isMovingFromParent {
            self.plugin?.fireStop()
            self.plugin?.removeAdapter()
            self.plugin?.removeAdsAdapter()
        }
        
    }
}

// MARK: - Video Player methods
extension PlayerViewController {
    private func initializePlayer() {
        guard let tmpResource = self.resource,
            let url = URL(string: tmpResource) else {
                return
        }
        
        // Video player controller
        self.playerViewController = AVPlayerViewController()
        
        // Add view to the current screen
        self.addChild(playerViewController!)
        self.playerContainer.addSubview((self.playerViewController?.view)!)
        
        // We use the playerView view as a guide for the video
        self.playerViewController?.view.frame = self.playerContainer.frame
        
        // Create AVPlayer
        
        let player = AVPlayer(url: url)
        self.playerViewController?.player = player
        
        self.plugin?.adapter = YBAVPlayerAdapterSwiftTranformer.transform(from: YBAVPlayerAdapter(player: player))
        
       
        // Start playback
        playerViewController?.player?.play()
        self.plugin?.adapter?.fireStart()
    }
}

// MARK: - Ads Methods
extension PlayerViewController {
    func initializeAds() {
        guard let containAds = self.containAds else {
            return
        }
        
        if containAds {
            self.adsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkAdsToBePlayed), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func checkAdsToBePlayed() {
        guard let currentPlayhead = self.playerViewController?.player?.currentTime() else {
            return
        }
        
        if self.currentAdLink != nil { return }
        
        if (currentAdPosition > (self.adsInterval.count - 1)) { return }
        
        if CMTimeGetSeconds(currentPlayhead) < Double(self.adsInterval[self.currentAdPosition]) {
            return
        }
        
        self.currentAdPosition = self.currentAdPosition + 1
        
        self.currentAdLink = AdResource.bitdash
        
        guard let nextAd = URL(string: AdResource.bitdash) else { return }
        
        self.playerViewController?.player?.pause()
        
        // Video player controller
        self.adsPlayerViewController = AVPlayerViewController()
        
        // Add view to the current screen
        self.addChild(adsPlayerViewController!)
        self.view.addSubview((self.adsPlayerViewController?.view)!)
        
        // We use the playerView view as a guide for the video
        self.adsPlayerViewController?.view.frame = self.view.frame
        
        // Create AVPlayer
        let adsPlayer = AVPlayer(url: nextAd)
        self.adsPlayerViewController?.player = adsPlayer
        
        self.plugin?.options.adResource = self.currentAdLink
        
        self.plugin?.adsAdapter = YBAVPlayerAdapterSwiftTranformer.transform(from: YBAVPlayerAdsAdapter(player: adsPlayer))
        
        NotificationCenter.default.addObserver(self, selector: #selector(adDidFinish), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        // Start playback
        adsPlayerViewController?.player?.play()
    }
    
    @objc func adDidFinish() {
        self.adsPlayerViewController?.view.removeFromSuperview()
        self.adsPlayerViewController?.removeFromParent()
        self.adsPlayerViewController = nil
        
        self.playerViewController?.player?.play()
        
        self.currentAdLink = nil
        self.plugin?.removeAdsAdapter()
    }
}
