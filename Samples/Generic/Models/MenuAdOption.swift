//
//  MenuAdOption.swift
//  Samples
//
//  Created by nice on 17/12/2019.
//  Copyright © 2019 npaw. All rights reserved.
//

import Foundation

@objcMembers open class MenuAdOption: NSObject {
    var title: String {
        return "MenuAdOption"
    }
    
    var adLink: String
    
    
    init(adLink: String?) {
        guard let adLink = adLink else {
            self.adLink = ""
            return
        }
        
        self.adLink = adLink
    }
    
    override init() {
        self.adLink = ""
    }
    
    static func == (lhs: MenuAdOption, rhs: MenuAdOption) -> Bool {
        return lhs.title == rhs.title
    }
}

@objcMembers class NoAdsOption: MenuAdOption {
    override var title: String {
        return "No Ads"
    }
}

@objcMembers class AdOption: MenuAdOption {
    override var title: String {
        return "Ad"
    }
}

@objcMembers class ImaOption: MenuAdOption {
    override var title: String {
        return "Ima"
    }
}

@objcMembers class ImaDaiOption: MenuAdOption {
    override var title: String {
        return "ImaDai"
    }
}

@objcMembers class FreewheelOption: MenuAdOption {
    override var title: String {
        return "Freewheel"
    }
}
