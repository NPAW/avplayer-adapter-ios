//
//  PlayerViewModel.swift
//  AVPlayerAdapterExample
//
//  Created by nice on 23/09/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

import Foundation
import YouboraAVPlayerAdapter
import AVKit

@objc class PlayerViewModelSwift: NSObject {
    private var options:YBOptions {
        get {
            let options = YBOptions()
            options.offline = false
            return options
        }
    }
    
    private let videoUrlString: String
    
    public var videoUrl: NSURL {
        get {
            return NSURL(string: self.videoUrlString)!
        }
    }
    
    lazy var plugin:YBPlugin = YBPlugin(options: options)
    
    var wrapper:YBAVPlayerAdapterSwiftWrapper? = nil;
    
    @objc init(url: String) {
        YBLog.setDebugLevel(.verbose)
        self.videoUrlString = url
    }
    
    public func startYoubora(player: AVPlayer?) {
        guard let nonOptionalPlayer = player else {
            return
        }
        
        self.plugin.fireInit()
        self.wrapper = YBAVPlayerAdapterSwiftWrapper(adapter: YBAVPlayerAdapter(player: nonOptionalPlayer), andPlugin: self.plugin);
    }
    
    public func stopYoubora() {
        self.wrapper?.removeAdapter()
    }
}
