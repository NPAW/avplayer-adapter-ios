//
//  VideoResourceViewModel.swift
//  Samples
//
//  Created by nice on 21/11/2019.
//  Copyright © 2019 nice. All rights reserved.
//

import Foundation

class VideoResourceViewModel {
    private let videoResource: MenuResourceOption;
    
    init(videoResource: MenuResourceOption) {
        self.videoResource = videoResource
    }
    
    func getUrl() -> String {
        return self.videoResource.resourceLink
    }
    
    func getType() -> String {
        return self.videoResource.title
    }
}
