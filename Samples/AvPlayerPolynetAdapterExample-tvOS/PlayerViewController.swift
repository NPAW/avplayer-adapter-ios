//
//  PlayerViewController.swift
//  AvPlayerPolynetAdapterExample-tvOS
//
//  Created by nice on 23/01/2020.
//  Copyright © 2020 npaw. All rights reserved.
//

import UIKit
import PolyNetSDK
import AVKit
import YouboraLib
import YouboraConfigUtils
import YouboraAVPlayerAdapter

class PlayerViewController: UIViewController {
    // MARK: Properties
    var polyNet: PolyNet?
    var playerViewController: AVPlayerViewController?
    
    var player: AVPlayer?
    var bufferEmptyCountermeasureTimer : Timer? = nil
    
    var manifestUrl: String?
    var channelId: String?
    var apiKey: String?
    
    var options: YBOptions {
        let options = YouboraConfigManager.getOptions()
        options.contentResource = self.manifestUrl
        options.autoDetectBackground = true
        return options;
    }
    
    lazy var plugin = YBPlugin(options: self.options)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        YBLog.setDebugLevel(.debug)
        
        self.navigationItem.title = "PolyNet SDK sample app menu"
        
        do {
            // Create the PolyNet
            polyNet = try PolyNet(manifestUrl: manifestUrl!, channelId: channelId, apiKey: apiKey!)
            polyNet?.logLevel = .debug
            polyNet?.dataSource = self
            polyNet?.delegate = self
            
            // Configure and start player
            player = AVPlayer(url: URL(string:polyNet!.localManifestUrl)!)
            playerViewController = AVPlayerViewController()
            playerViewController?.player = player
            
            // Add view to the current screen
            self.addChildViewController(playerViewController!)
            self.view.addSubview((self.playerViewController?.view)!)
            
            // We use the playerView view as a guide for the video
            self.playerViewController?.view.frame = self.view.frame
            
            let normalAdapter = YBAVPlayerPolynetAdapter(polyNet: polyNet, player: player)
            normalAdapter.supportPlaylists = false
            plugin.adapter = YBAVPlayerAdapterSwiftTranformer.transform(from: normalAdapter)
            
            plugin.fireInit()
            
            self.addObserversForPlayerItem(playerItem: (self.player?.currentItem)!)
        } catch  {
            let alert = UIAlertController(title: error.localizedDescription, message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
            self.present(alert, animated: true, completion: nil)
            print("PolyNet Error: creating PolyNet object")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.isMovingFromParentViewController {
            self.deactivateBufferEmptyCountermeasure()
            self.plugin.fireStop()
            self.plugin.removeAdapter()
        }
    }
}

// MARK: PolyNetDataSource
extension PlayerViewController: PolyNetDataSource {
    
    // PolyNet requests the buffer health of the video player.
    // This is the current buffered time ready to be played.
    func playerBufferHealth(in: PolyNet) -> NSNumber? {
        // Get player time ranges. If not, return nil
        guard let timeRanges: [NSValue] = player?.currentItem?.loadedTimeRanges,
            timeRanges.count > 0,
            let currentTime = player?.currentItem?.currentTime()
            else {
                return nil
        }
        // Get the valid time range from time ranges, return nil if not valid one.
        guard let timeRange = getTimeRange(timeRanges: timeRanges, forCurrentTime: currentTime) else {
            return nil
        }
        let end = timeRange.end.seconds
        return max(end - currentTime.seconds, 0) as NSNumber
    }
    
    func getTimeRange(timeRanges: [NSValue], forCurrentTime time: CMTime) -> CMTimeRange? {
        let timeRange = timeRanges.first(where: { (value) -> Bool in
            CMTimeRangeContainsTime(value.timeRangeValue, time)
        })
        // Workaround: When pause the player, the item loaded ranges moves whereas the current time
        // remains equal. In time, the current time is out of the range, so the buffer health cannot
        // be calculated. For this reason, when there is not range for current item, the first range
        // is returned to calculate the buffer with it.
        if timeRange == nil && timeRanges.count > 0 {
            return timeRanges.first!.timeRangeValue
        }
        return timeRange?.timeRangeValue
    }
    
    // PolyNet request the dropped video frames. This is the accumulated number of dropped video frames for the player.
    func playerAccumulatedDroppedFrames(in: PolyNet) -> NSNumber? {
        
        // If no events, return nil
        guard let event = player?.currentItem?.accessLog()?.events.last else {
            return nil
        }
        
        // Get the last event and return the dropped frames. If the value is negative, the value is unknown according to the API. In such cases return nil.
        let numberOfDroppedVideoFrames = event.numberOfDroppedVideoFrames
        if (numberOfDroppedVideoFrames < 0) {
            return nil
        } else {
            return numberOfDroppedVideoFrames as NSNumber
        }
    }
    
    // PolyNet request the started date of the playback. This is the date when the player started to play the video
    func playerPlaybackStartDate(in: PolyNet) -> Date? {
        
        // If no events, return nil
        guard let event = player?.currentItem?.accessLog()?.events.last else {
            return nil
        }
        return event.playbackStartDate
    }
}

// MARK: PolyNetDelegate
extension PlayerViewController: PolyNetDelegate {
 
    /// PolyNet Updated Metrics Delegate Method
    ///
    /// - Parameters:
    ///   - polyNet: The PolyNet instance to which the metrics object belong.
    ///   - metrics: An updated PolyNetMetrics Object.
    func polyNet(_ polyNet: PolyNet, didUpdate metrics: PolyNetMetrics) {
        // TODO: You can now access the new metrics object.
    }
    
    /// PolyNet did fail Delegate Method
    ///
    /// - Parameters:
    ///   - polyNet: The PolyNet instance where the error generated.
    ///   - error: A PolyNet Error. See the debugging section in the docs for more info at: https://system73.com/docs/
    func polyNet(_ polyNet: PolyNet, didFailWithError error: Error) {
        // TODO: Manage the error if needed.
        print("PolyNet error: " + error.localizedDescription)
    }
}

// Extension to handle connection lost and playback recovery
extension PlayerViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (#keyPath(AVPlayerItem.status) == keyPath) {
            let playerItem = object as! AVPlayerItem
            switch playerItem.status {
            case .readyToPlay:
                self.handlePlayerItemReadyToPlay()
                break
            case .unknown, .failed: fallthrough
            @unknown default:
                break
            }
            
        }
        
        if (keyPath == #keyPath(AVPlayerItem.isPlaybackBufferEmpty)) {
            handlePlaybackBuferEmpty(playerItem: object as! AVPlayerItem)
        }
        
        if (keyPath == "currentTime") {
            let newItem = change?[NSKeyValueChangeKey.newKey]
            let oldItem = change?[NSKeyValueChangeKey.oldKey]
            
            print("Test Cenas -> Old: \(oldItem) New: \(newItem)")
        }
    }
    
    func addObserversForPlayerItem(playerItem: AVPlayerItem) {
       
        playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.initial , .new, .old], context: nil)
        playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackBufferEmpty), options: [.initial , .new], context: nil)
    }
    
    func removeObserversForPlayerItem(playerItem: AVPlayerItem) {
            playerItem.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
            playerItem.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackBufferEmpty))
    }
    
    func handlePlayerItemReadyToPlay() {
        player?.play()
        deactivateBufferEmptyCountermeasure()
    }
    
    func handlePlaybackBuferEmpty(playerItem: AVPlayerItem) {
        if (playerItem.status == .readyToPlay) {
            activateBufferEmptyCountermeasure()
        }
    }
    
    func activateBufferEmptyCountermeasure() {
        guard bufferEmptyCountermeasureTimer == nil else {
            return
        }
        
        if #available(tvOS 10.0, *) {
            bufferEmptyCountermeasureTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
                let currentItem: AVPlayerItem = (self.player?.currentItem)!
                self.removeObserversForPlayerItem(playerItem: currentItem)
                
                let asset = currentItem.asset
                
                guard let urlAsset = asset as? AVURLAsset else {
                    return
                }
                
                let item: AVPlayerItem = AVPlayerItem.init(url: urlAsset.url)
                self.addObserversForPlayerItem(playerItem: item)
                self.player?.replaceCurrentItem(with: item)
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func deactivateBufferEmptyCountermeasure() {
        guard bufferEmptyCountermeasureTimer != nil else {
            return
        }
        
        bufferEmptyCountermeasureTimer?.invalidate()
        bufferEmptyCountermeasureTimer = nil
    }
    
}

