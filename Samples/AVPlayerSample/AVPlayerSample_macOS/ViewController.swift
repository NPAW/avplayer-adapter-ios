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
        
        let options = YBOptions()
        
        options.accountCode = "powerDev"
        options.offline = false
        
        self.plugin = YBPlugin(options: options)
        
        self.initializePlayer()
    }
    
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        self.plugin?.fireStop()
        self.plugin?.removeAdapter()
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
        guard let resourceUrl = URL(string: Resource.lhsApple) else {
            return
        }
        
        // Video player controller
        let playerView = AVPlayerView()
        playerView.frame = self.view.frame
        
        self.view.addSubview(playerView)
        
        let player = AVPlayer(url: resourceUrl)
        
        // Create AVPlayer
        playerView.player = player
        
        plugin?.adapter = YBAVPlayerAdapterSwiftTranformer.transform(from: YBAVPlayerAdapter(player: player))
        
        // Start playback
        playerView.player?.play()
    }
}
