//
//  ViewController.swift
//  AvPlayerAdapterExample-macOS
//
//  Created by nice on 16/12/2019.
//  Copyright © 2019 npaw. All rights reserved.
//

import Cocoa
import AVKit
import YouboraAVPlayerAdapter

class ViewController: NSViewController {
    
    @IBOutlet weak var playerView: AVPlayerView!
    
    fileprivate var viewModel = MenuViewModel().getPlayerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializePlayer()
    }
    
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        self.viewModel?.stopYoubora()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

// MARK: - Video Player methods
extension ViewController {
    private func initializePlayer() {
        guard let resourceUrl = viewModel?.getVideoUrl() else {
            return
        }
        
        // Video player controller
        let playerView = AVPlayerView()
        playerView.frame = self.view.frame
        
        self.view.addSubview(playerView)
        
        // Create AVPlayer
        playerView.player = AVPlayer(url: resourceUrl)
        
        self.viewModel?.startYoubora(with: playerView.player)
        
        // Start playback
        playerView.player?.play()
    }
}
