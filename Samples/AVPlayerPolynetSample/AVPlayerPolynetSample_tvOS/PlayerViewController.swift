//
//  PlayerViewController.swift
//  AVPlayerPolynetSample_tvOS
//
//  Created by Tiago Pereira on 18/09/2020.
//  Copyright © 2020 NicePeopleAtWork. All rights reserved.
//

import AVKit
import UIKit
import YouboraLib
import PolyNetSDK
import YouboraConfigUtils
import YouboraAVPlayerAdapter

struct PolynetConstants {
    static let POLYNET_KEY = "eyJoYXNoZWRfa2V5IjoiWTdWUEJkQzZKdy1JMk1VTEZhWnp3UUpiV3BaOVBhdFpDeTU3VFNoMWhOYyIsInNpZ25hbF9zZXJ2ZXJfdXJsIjoid3NzOlwvXC9lbWVhLnM3M2Nsb3VkLmNvbTo0NDNcL3dzIiwic3R1bl9zZXJ2ZXJfdXJsIjpbInN0dW46c3R1bi1lbWVhLTAxLnM3M2Nsb3VkLmNvbTozNDc4Iiwic3R1bjpzdHVuLWVtZWEtMDIuczczY2xvdWQuY29tOjM0NzgiXSwibWV0cmljX3NpbmtfdXJsIjoiaHR0cHM6XC9cL2VtZWEuczczY2xvdWQuY29tOjQ0M1wvbWV0cmljc1wvdjEifQ=="
    static let POLYNET_RESOURCE_ULR = "https://s73-streams.s3.amazonaws.com/sintel/manifest.m3u8"
}

class PlayerViewController: UIViewController, PolyNetDataSource {
    var resource: String?
    var containAds: Bool?
    
    var plugin: YBPlugin?
    
    var playerViewController:AVPlayerViewController?
    
    var adsPlayerViewController:AVPlayerViewController?
    var adsTimer: Timer?
    
    var playerContainer = UIView()
    
    var polyNet: PolyNet?
    
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
        
        options.contentResource = self.resource
        
        self.plugin = YBPlugin(options: options)
        
        playerContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerContainer)
        NSLayoutConstraint.activate([
            playerContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            playerContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            playerContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            playerContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
        
        self.setPolynet()
        
        // Initialize player on this view controller
        self.initializePlayer()
        self.initializeAds()
    }
    
    
    @objc func sendOffline() {
        
    }
    
    @objc func pressToReply() {
        self.playerViewController?.player?.seek(to: .init(value: .zero, timescale: .zero))
        self.playerViewController?.player?.play()
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
        
        if self.isMovingFromParentViewController {
            plugin?.fireStop()
            plugin?.removeAdapter()
            plugin?.removeAdsAdapter()
        }
        
    }
}

// MARK: - Video Player methods
extension PlayerViewController {
    private func initializePlayer() {
        // Video player controller
        self.playerViewController = AVPlayerViewController()
        
        // Add view to the current screen
        self.addChildViewController(playerViewController!)
        self.playerContainer.addSubview((self.playerViewController?.view)!)
        
        // We use the playerView view as a guide for the video
        self.playerViewController?.view.frame = self.playerContainer.frame
        
        if let polynet = self.polyNet,
            let url = URL(string: polynet.localManifestUrl) {
            
            let playerItem = AVPlayerItem(url:url)
            
            let player = AVPlayer(playerItem: playerItem)
            self.playerViewController?.player = player
            
            plugin?.adapter = YBAVPlayerAdapterSwiftTranformer.transform(from: YBAVPlayerPolynetAdapter(polyNet: polynet, player: player))
            
            self.playerViewController?.player?.play()
        }
    }
}

//MARK: Polynet Section
extension PlayerViewController {
    func setPolynet() {
        guard let resourcePath = resource else {
            return
        }
        do {
            self.polyNet = try PolyNet(manifestUrl: resourcePath, channelId: nil, apiKey: PolynetConstants.POLYNET_KEY)
            self.polyNet?.dataSource = self
        } catch { print("Something went wrong") }
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
        
        self.currentAdLink = ""
        
        guard let nextAd = URL(string: "") else { return }
        
        self.playerViewController?.player?.pause()
        
        // Video player controller
        self.adsPlayerViewController = AVPlayerViewController()
        
        // Add view to the current screen
        self.addChildViewController(adsPlayerViewController!)
        self.view.addSubview((self.adsPlayerViewController?.view)!)
        
        // We use the playerView view as a guide for the video
        self.adsPlayerViewController?.view.frame = self.view.frame
        
        // Create AVPlayer
        let adsPlayer = AVPlayer(url: nextAd)
        self.adsPlayerViewController?.player = adsPlayer
        
        plugin?.options.adResource = self.currentAdLink
        
        plugin?.adapter = YBAVPlayerAdapterSwiftTranformer.transform(from: YBAVPlayerAdsAdapter(player: adsPlayer))
        
        NotificationCenter.default.addObserver(self, selector: #selector(adDidFinish), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        // Start playback
        adsPlayerViewController?.player?.play()
    }
    
    @objc func adDidFinish() {
        self.adsPlayerViewController?.view.removeFromSuperview()
        self.adsPlayerViewController?.removeFromParentViewController()
        self.adsPlayerViewController = nil
        
        self.playerViewController?.player?.play()
        
        self.currentAdLink = nil
        plugin?.removeAdsAdapter()
    }
}


