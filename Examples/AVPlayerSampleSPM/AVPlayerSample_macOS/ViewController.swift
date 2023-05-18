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
    
    var plugin: YBPlugin?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        YBLog.setDebugLevel(.debug)
        
        let options = YBOptions()
        
        options.accountCode = "nicetest"
        options.offline = false
        
        plugin = YBPlugin(options: options)
        
        initializePlayer()
    }
    
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        plugin?.fireStop()
        plugin?.removeAdapter()
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
        guard let resourceUrl = URL(string: Resource.hlsApple) else {
            return
        }
        
        // Video player controller
        let playerView = AVPlayerView()
        playerView.frame = view.frame
        
        view.addSubview(playerView)
        
        let player = AVPlayer(url: resourceUrl)
        
        // Create AVPlayer
        playerView.player = player
        
        plugin?.adapter = YBAVPlayerAdapterSwiftTranformer.transform(from: YBAVPlayerAdapter(player: player))
        
        // Start playback
        playerView.player?.play()
    }
}
