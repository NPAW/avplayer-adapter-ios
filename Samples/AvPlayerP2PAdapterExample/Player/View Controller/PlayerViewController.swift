//
//  PlayerViewController.swift
//  AvPlayerP2PAdapterExample
//
//  Created by nice on 18/12/2019.
//  Copyright © 2019 npaw. All rights reserved.
//

import Foundation
import StreamrootSDK
import AVKit

class PlayerViewController: UIViewController {
    var viewModel: AvPlayerExampleViewModel?
    
    var dnaClient: DNAClient?
    
    var playerViewController: AVPlayerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        if viewModel.getSelectedP2P() == .Streamroot {
            self.setStreamroot()
        } else {
            self.setSystem73()
        }
        
        setPlayer()
        
    }
}

//MARK: Player Section

extension PlayerViewController {
    func setPlayer() {
        guard let viewModel = self.viewModel else {
            return
        }
        
        let playerViewController = AVPlayerViewController()
        self.addChild(playerViewController)
        
        self.view.addSubview(playerViewController.view)
        playerViewController.view.frame = self.view.frame
        
        if let dnaClient = self.dnaClient,
            let manifestLocalURLPath = dnaClient.manifestLocalURLPath,
            let url = URL(string: manifestLocalURLPath) {
            
            let playerItem = AVPlayerItem(url:url)
            
            if #available(iOS 10.2, *) {
                playerItem.preferredForwardBufferDuration = dnaClient.bufferTarget
            }
            
            playerViewController.player = AVPlayer(playerItem: playerItem)
            
            self.playerViewController = playerViewController
            
            viewModel.startYoubora(with: self.playerViewController?.player, andDnaClient: dnaClient)
            
            self.playerViewController?.player?.play()
            
            return
        }
    }
}

//MARK: Streamroot Section
extension PlayerViewController: DNAClientDelegate {
    func setStreamroot() {
        guard let manifestUrl = self.viewModel?.getVideoUrl() else {
            return
        }
        do {
            self.dnaClient = try DNAClient.builder().dnaClientDelegate(self).latency(30).start(manifestUrl)
        } catch { print("Something went wrong") }
    }
    
    func playbackTime() -> Double {
        guard let player = self.playerViewController?.player else {
            return 0
        }
        
        return CMTimeGetSeconds(player.currentTime())
    }
    
    func loadedTimeRanges() -> [NSValue] {
        guard let currentItem = self.playerViewController?.player?.currentItem else {
            return []
        }
        
        return currentItem.loadedTimeRanges.map{ value in
            return NSValue(timeRange: value.timeRangeValue)
        }
    }
    
    func updatePeakBitRate(_ bitRate: Double) {
        guard let currentItem = self.playerViewController?.player?.currentItem else {
            return
        }
        
        currentItem.preferredPeakBitRate = bitRate
    }
}

//MARK: System 73 Section
extension PlayerViewController {
    func setSystem73() {
        
    }
}
