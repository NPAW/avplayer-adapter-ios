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
        guard let containAds = containAds else { return  [] }
        
        if containAds { return [10, 20, 30] }
        
        return []
    }
    
    var currentAdPosition = 0
    var currentAdLink: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let options = YouboraConfigManager.getOptions()

        options.contentIsLive = NSNumber(value: resource == Resource.live || resource == Resource.liveAirShow)
        options.contentResource = resource
        
        plugin = YBPlugin(options: options)
        
        changeItemButton.setTitle("Change Item", for: .normal)
        
        changeItemButton.addTarget(self, action: #selector(changeItem), for:.touchUpInside)
        changeItemButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(changeItemButton)
        NSLayoutConstraint.activate([
            changeItemButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            changeItemButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            changeItemButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            changeItemButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        buttonReplay.setTitle("Replay", for: .normal)
        buttonReplay.addTarget(self, action: #selector(pressToReply), for:.touchUpInside)
        buttonReplay.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonReplay)
        NSLayoutConstraint.activate([
            buttonReplay.topAnchor.constraint(equalTo: changeItemButton.bottomAnchor, constant: 20),
            buttonReplay.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            buttonReplay.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            buttonReplay.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        playerContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerContainer)
        NSLayoutConstraint.activate([
            playerContainer.topAnchor.constraint(equalTo: buttonReplay.bottomAnchor, constant: 0),
            playerContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            playerContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            playerContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        // Initialize player on this view controller
        initializePlayer()
        initializeAds()
    }
    
    
    @objc func changeItem() {
        guard let newResource = [
            Resource.hlsApple,
            Resource.hlsTest
        ].randomElement(), let url = URL(string: newResource) else {
            return
        }
        plugin?.options.contentIsLive = NSNumber(false)
        playerViewController?.player?.replaceCurrentItem(with: AVPlayerItem(url: url))
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
        if let adsTimer = adsTimer {
            adsTimer.invalidate()
            self.adsTimer = nil
        }
        
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
        
       
        // Start playback
        playerViewController?.player?.play()
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
