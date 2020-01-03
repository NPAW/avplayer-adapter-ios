//
//  MenuResourceOption.swift
//  Samples
//
//  Created by nice on 17/12/2019.
//  Copyright © 2019 npaw. All rights reserved.
//

import Foundation

@objcMembers open class MenuResourceOption: NSObject {
    var title: String {
        return "MenuResourceOptoin"
    }
    
    var isLive: Bool {
        return false
    }
    
    var resourceLink: String
    
    init(resourceLink : String) {
        self.resourceLink = resourceLink
    }
}

@objcMembers class NormalResource:MenuResourceOption {
    override var title: String {
        return "Normal"
    }
}

@objcMembers class LhsResource:MenuResourceOption {
    override var title: String {
        return "LHS"
    }
}

@objcMembers class DashResource:MenuResourceOption {
    override var title: String {
        return "Dash"
    }
}

@objcMembers class LiveResource:MenuResourceOption {
    override var title: String {
        return "Live"
    }
    
    override var isLive: Bool {
        return true
    }
}

@objcMembers class BrokenResource:MenuResourceOption {
    override var title: String {
        return "Broken"
    }
}

@objcMembers class UnknownResource:MenuResourceOption {
    override var title: String {
        return "Unknown"
    }
}
