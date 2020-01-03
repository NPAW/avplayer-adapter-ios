//
//  PlayerViewModelSwift.swift
//  AvPlayerP2PAdapterExample
//
//  Created by nice on 18/12/2019.
//  Copyright © 2019 npaw. All rights reserved.
//

import Foundation
import YouboraLib
import YouboraConfigUtils
import YouboraAVPlayerAdapter
import StreamrootSDK

class AvPlayerExampleViewModelSwift: AvPlayerExampleViewModel {
    var options: YBOptions {
        let options = YouboraConfigManager.getOptions()
        options.offline = false
        options.contentResource = self.resource.resourceLink
        options.accountCode = "powerdev"
        options.adResource = self.ad?.adLink
        options.contentIsLive = NSNumber(value: self.resource.isLive)
        return options;
    }
    
    lazy var plugin = YBPlugin(options: self.options)
    
    private (set) var resource: MenuResourceOption;
    private (set) var ad: MenuAdOption?;
    
    private (set) var selectedP2P: AvailableP2P?;
    
    private var adsInterval: [Int] {
        if self.containAds() {
            return [10,20,30]
        }
        
        return []
    }
    
    var currentAdPosition = 0
    var currentAdLink: String?
    
    init(resource: MenuResourceOption, ad: MenuAdOption?) {
        self.resource = resource
        self.ad = ad
    }
    
    func getSelectedP2P() -> AvailableP2P {
         guard let selectedP2P = self.selectedP2P else {
             return .Streamroot
         }
         return selectedP2P
     }
    
    func setSelectedP2P(_ selectedP2P: AvailableP2P) {
        self.selectedP2P = selectedP2P
    }
    
    func startYoubora(with player: AVPlayer?, andDnaClient dnaClient: DNAClient?) {
        self.plugin.fireInit()
        
        self.plugin.adapter = YBAVPlayerAdapterSwiftTranformer.transform(from: YBAVPlayerP2PAdapter(dnaClient: dnaClient, andPlayer: player))
    }
    
    func getVideoUrl() -> URL? {
        return URL(string: self.resource.resourceLink)
    }
    
    func getNextAd(_ currentPlayhead: Double) -> URL? {
        guard let ad = self.ad else { return nil }
        
        if self.currentAdLink != nil { return nil }
        
        if (currentAdPosition > (self.adsInterval.count - 1)) { return nil }
        
        if currentPlayhead < Double(self.adsInterval[self.currentAdPosition]) {
            return nil
        }
        
        self.currentAdPosition = self.currentAdPosition + 1
        
        self.currentAdLink = ad.adLink
        
        return URL(string: ad.adLink)
    }
    
    func containAds() -> Bool {
        guard let ad = self.ad else {
            return false
        }
        
        return !(ad is NoAdsOption)
    }
    
    func setAdsAdapterWith(_ player: AVPlayer?) {
        guard let player = player else {
            return
        }
        
        self.plugin.adsAdapter = YBAVPlayerAdapterSwiftTranformer.transform(from: YBAVPlayerAdsAdapter(player: player))
    }
    
    func adsDidFinish() {
        self.currentAdLink = nil
        self.plugin.removeAdsAdapter()
    }
    
    func stopYoubora() {
        self.plugin.fireStop()
        self.plugin.removeAdapter()
        self.plugin.removeAdsAdapter()
    }
}
