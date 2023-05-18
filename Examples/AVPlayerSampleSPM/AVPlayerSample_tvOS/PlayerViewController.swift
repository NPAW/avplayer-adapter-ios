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
    
    var plugin: YBPlugin?
    
    var playerViewController:AVPlayerViewController?
    
    var adsPlayerViewController:AVPlayerViewController?
    var adsTimer: Timer?
    
    var playerContainer = UIView()
    
    private var adsInterval: [Int] {
        guard let containAds = containAds else { return  [] }
        
        if containAds { return [10,20,30] }
        
        return []
    }
    
    var currentAdPosition = 0
    var currentAdLink: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let options = YouboraConfigManager.getOptions()
        
        options.contentIsLive = NSNumber(value: resource == Resource.live)
        options.contentResource = resource
        
        plugin = YBPlugin(options: options)
        
        playerContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerContainer)
        NSLayoutConstraint.activate([
            playerContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            playerContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            playerContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            playerContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        // Initialize player on this view controller
        initializePlayer()
        initializeAds()
    }
    
    
    @objc func sendOffline() {
        
    }
    
    @objc func pressToReply() {
        playerViewController?.player?.seek(to: .zero)
        playerViewController?.player?.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let adsTimer = adsTimer else {
            return
        }
        
        adsTimer.invalidate()
        self.adsTimer = nil
        
        if isMovingFromParent {
            plugin?.fireStop()
            plugin?.removeAdapter()
            plugin?.removeAdsAdapter()
        }
        
    }
}

// MARK: - Video Player methods
extension PlayerViewController {
    private func initializePlayer() {
        guard let tmpResource = resource,
            let url = URL(string: tmpResource) else {
                return
        }
        
        // Video player controller
        playerViewController = AVPlayerViewController()
        
        // Add view to the current screen
        addChild(playerViewController!)
        playerContainer.addSubview((playerViewController?.view)!)
        
        // We use the playerView view as a guide for the video
        playerViewController?.view.frame = playerContainer.frame
        
        // Create AVPlayer
        
        let player = AVPlayer(url: url)
        playerViewController?.player = player
        
        plugin?.adapter = YBAVPlayerAdapterSwiftTranformer.transform(from: YBAVPlayerAdapter(player: player))
        plugin?.fireInit()
    }
}

// MARK: - Ads Methods
extension PlayerViewController {
    func initializeAds() {
        guard let containAds = containAds else {
            return
        }
        
        if containAds {
            adsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkAdsToBePlayed), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func checkAdsToBePlayed() {
        guard let currentPlayhead = playerViewController?.player?.currentTime() else {
            return
        }
        
        if currentAdLink != nil { return }
        
        if (currentAdPosition > (adsInterval.count - 1)) { return }
        
        if CMTimeGetSeconds(currentPlayhead) < Double(adsInterval[currentAdPosition]) {
            return
        }
        
        currentAdPosition = currentAdPosition + 1
        
        currentAdLink = AdResource.bitdash
        
        guard let nextAd = URL(string: AdResource.bitdash) else { return }
        
        playerViewController?.player?.pause()
        
        // Video player controller
        adsPlayerViewController = AVPlayerViewController()
        
        // Add view to the current screen
        addChild(adsPlayerViewController!)
        view.addSubview((adsPlayerViewController?.view)!)
        
        // We use the playerView view as a guide for the video
        adsPlayerViewController?.view.frame = view.frame
        
        // Create AVPlayer
        let adsPlayer = AVPlayer(url: nextAd)
        adsPlayerViewController?.player = adsPlayer
        
        plugin?.options.adResource = currentAdLink
        
         plugin?.adsAdapter = YBAVPlayerAdapterSwiftTranformer.transform(from: YBAVPlayerAdsAdapter(player: adsPlayer))
        
        NotificationCenter.default.addObserver(self, selector: #selector(adDidFinish), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        // Start playback
        adsPlayerViewController?.player?.play()
    }
    
    @objc func adDidFinish() {
        adsPlayerViewController?.view.removeFromSuperview()
        adsPlayerViewController?.removeFromParent()
        adsPlayerViewController = nil
        
        playerViewController?.player?.play()
        
        currentAdLink = nil
        plugin?.removeAdsAdapter()
    }
}
