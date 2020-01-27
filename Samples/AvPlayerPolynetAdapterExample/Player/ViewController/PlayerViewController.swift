//
//  PlayerViewController.swift
//  AvPlayerPolynetAdapterExample
//
//  Created by nice on 09/01/2020.
//  Copyright © 2020 npaw. All rights reserved.
//

import UIKit
import PolyNetSDK

class PlayerViewController: UIViewController {
    
    var viewModel: AvPlayerExampleViewModel?
    
    var polyNet: PolyNet?
    
    var playerViewController: AVPlayerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setPolynet()
        
        setPlayer()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isBeingDismissed || self.isMovingFromParent {
            self.viewModel?.stopYoubora()
        }
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
        
        if let polynet = self.polyNet,
            let url = URL(string: polynet.localManifestUrl) {
            
            let playerItem = AVPlayerItem(url:url)
            
            playerViewController.player = AVPlayer(playerItem: playerItem)
            
            self.playerViewController = playerViewController
            
            viewModel.startYoubora(with: self.playerViewController?.player, polynet: self.polyNet, andPolynetDelegate: self)
            
            self.playerViewController?.player?.play()
            
            return
        }
    }
}

//MARK: Polynet Section
extension PlayerViewController {
    func setPolynet() {
        guard let manifestUrl = self.viewModel?.getVideoUrl()?.absoluteString else {
            return
        }
        do {
            self.polyNet = try PolyNet(manifestUrl: manifestUrl, channelId: nil, apiKey: PolynetConstants.POLYNET_KEY)
            self.polyNet?.dataSource = self
        } catch { print("Something went wrong") }
    }
}

// MARK: PolyNetDelegate
extension PlayerViewController: PolyNetDelegate {
    
    func polyNet(_ polyNet: PolyNet, didUpdate metrics: PolyNetMetrics) {
        // TODO: You can now access the new metrics object.
    }

    func polyNet(_ polyNet: PolyNet, didFailWithError error: Error) {
        // TODO: Manage the error if needed.
        print("PolyNet error: " + error.localizedDescription)
    }
}

// MARK: PolyNetDataSource
extension PlayerViewController: PolyNetDataSource {

    // PolyNet requests the buffer health of the video player.
    // This is the current buffered time ready to be played.
    func playerBufferHealth(in: PolyNet) -> NSNumber? {
        guard let player = self.playerViewController?.player else {
            return nil
        }
        
        // Get player time ranges. If not, return nil
        guard let timeRanges: [NSValue] = player.currentItem?.loadedTimeRanges,
            timeRanges.count > 0,
            let currentTime = player.currentItem?.currentTime()
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
            CMTimeRangeContainsTime(value.timeRangeValue, time: time)
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
        guard let player = self.playerViewController?.player else {
            return nil
        }
        
        // If no events, return nil
        guard let event = player.currentItem?.accessLog()?.events.last else {
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
        guard let player = self.playerViewController?.player else {
            return nil
        }
        // If no events, return nil
        guard let event = player.currentItem?.accessLog()?.events.last else {
            return nil
        }
        return event.playbackStartDate
    }
}
