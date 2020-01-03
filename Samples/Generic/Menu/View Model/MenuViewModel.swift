//
//  MenuViewModel.swift
//  Samples
//
//  Created by nice on 17/12/2019.
//  Copyright © 2019 npaw. All rights reserved.
//

import Foundation

typealias UpdateClosure = () -> Void

@objcMembers class MenuViewModel {
    private var availableResources = [
        LhsResource(resourceLink: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"),
        DashResource(resourceLink: "http://livesim.dashif.org/livesim/testpic_2s/Manifest.mpd"),
        DashResource(resourceLink: "https://bitmovin-a.akamaihd.net/content/MI201109210084_1/mpds/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.mpd"),
        DashResource(resourceLink: "http://192.168.1.99/asd.mpd"),
        LiveResource(resourceLink: "http://aljazeera-ara-apple-live.adaptive.level3.net/apple/aljazeera/arabic/160.m3u8"),
        BrokenResource(resourceLink: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/l.m3u8")
    ]
    
    var selectedResourceDidUpdate: UpdateClosure?
    
    private (set) var selectedResource: MenuResourceOption {
        didSet {
            guard let selectedResourceDidUpdate = self.selectedResourceDidUpdate else {
                return
            }
            selectedResourceDidUpdate()
        }
    }
    
    private var availableAds:[MenuAdOption] = [
        AdOption(adLink: "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8"),
        NoAdsOption()
    ]
    
    var selectedAdDidUpdate: UpdateClosure?
    
    private (set) var selectedAd: MenuAdOption? {
        didSet {
            guard let selectedAdDidUpdate = self.selectedAdDidUpdate else {
                return
            }
            selectedAdDidUpdate()
        }
    }
    
    var selectedLanguage = AvailableLanguage.Swift
    
    init() {
        self.selectedResource = self.availableResources[0]
        
        if !self.availableAds.isEmpty {
            self.selectedAd = self.availableAds[0]
        }
    }
    
    func getPlayerViewModel() -> AvPlayerExampleViewModel? {
        if self.selectedLanguage == .Swift  {
            return AvPlayerExampleViewModelSwift(resource: self.selectedResource, ad: self.selectedAd)
        }
        
        return AvPlayerExampleViewModelObjc(self.selectedResource, andAd: self.selectedAd)
    }
}

// MARK: Links menu methods
extension MenuViewModel {
    func getNumberOfResources() -> Int {
        return self.availableResources.count
    }
    
    func getVRViewModel(position:Int) -> VideoResourceViewModel? {
        if position < 0 && position > self.getNumberOfResources() - 1 {
            return nil
        }
        return VideoResourceViewModel(videoResource: self.availableResources[position])
    }
    
    func getUrlToOption(position: Int) -> String? {
        if position < 0 && position > self.getNumberOfResources() - 1 {
            return nil
        }
        
        return self.availableResources[position].resourceLink
    }
    
    func didSelectNewResource(position:Int) {
        if position < 0 && position > self.getNumberOfResources() - 1 {
            return
        }
        
        self.selectedResource = self.availableResources[position]
    }
    
    func updateResourceLink(newLink: String?) {
        guard let newLink = newLink else {
            return
        }
        
        self.selectedResource = UnknownResource(resourceLink: newLink)
    }
}


// MARK: Ads menu methods
extension MenuViewModel {
    func areThereAds() -> Bool {
        return !self.availableAds.isEmpty
    }
    
    func getNumberOfAds() -> Int {
        return self.availableAds.count
    }
    
    func getAdTitle(position: Int) -> String {
        if position >= 0 && position <= self.getNumberOfAds()-1 {
            return "Unknown"
        }
        
        return self.availableAds[position].title
    }
    
    func getAdViewModel(position:Int) -> AdCellViewModel? {
        if position < 0 && position > self.getNumberOfAds() - 1 {
            return nil
        }
        return AdCellViewModel(ad: self.availableAds[position])
    }
    
    func didSelectNewAd(position:Int) {
        if position < 0 && position > self.getNumberOfAds() - 1 {
            return
        }
        
        self.selectedAd = self.availableAds[position]
    }
    
    func getCurrentAdPosition() -> Int? {
        guard let currenAd = self.selectedAd else {
            return nil
        }
        
        return self.availableAds.firstIndex(of: currenAd)
    }
    
    func updateAdLink(newLink: String?) {
        self.selectedAd = AdOption(adLink: newLink)
    }
}

// MARK: Language section
extension MenuViewModel {
    public func didSelectedNewLanguage(languageIndex: Int) {
        guard let newLanguage = AvailableLanguage(rawValue: languageIndex) else {
            return
        }
        
        self.selectedLanguage = newLanguage
    }
}
