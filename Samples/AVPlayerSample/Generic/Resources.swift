//
//  Resources.swift
//  AVPlayerSample
//
//  Created by Tiago Pereira on 17/09/2020.
//  Copyright © 2020 NicePeopleAtWork. All rights reserved.
//

import Foundation

struct Resource {
    static let hlsApple = "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"
    static let hlsTest = "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8"
    static let dashLivesim = "http://livesim.dashif.org/livesim/testpic_2s/Manifest.mpd"
    static let dashBitmovin = "https://bitmovin-a.akamaihd.net/content/MI201109210084_1/mpds/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.mpd"
    static let live = "http://aljazeera-ara-apple-live.adaptive.level3.net/apple/aljazeera/arabic/160.m3u8"
    static let liveAirShow = "http://cdn3.viblast.com/streams/hls/airshow/playlist.m3u8"
    static let broken = "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/l.m3u8"
}

struct AdResource {
    static let bitdash = "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8"
}
