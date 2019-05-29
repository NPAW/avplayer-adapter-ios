//
//  ViewController.swift
//  AVPlayerAdapterOSXExample
//
//  Created by Enrique Alfonso Burillo on 22/05/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

import Cocoa
import AVKit
import YouboraAVPlayerAdapter

class ViewController: NSViewController {
    @IBOutlet weak var playerView: AVPlayerView!
    
    fileprivate var ybPlugin: YBPlugin? = nil
    fileprivate var ybWrapper: YBAVPlayerAdapterSwiftWrapper? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        YBLog.setDebugLevel(.verbose)
        let options = YBOptions()
        options.offline = false
        self.ybPlugin = YBPlugin(options: options)
        self.ybPlugin?.fireInit()
        guard let url = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8") else {
            return
        }
        // Create a new AVPlayer and associate it with the player view
        let player = AVPlayer(url: url)
        playerView.player = player
        self.ybWrapper = YBAVPlayerAdapterSwiftWrapper(player: player, andPlugin: self.ybPlugin)
        playerView.player?.play()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    override func viewWillDisappear() {
        self.ybWrapper?.removeAdapter()
    }
}

