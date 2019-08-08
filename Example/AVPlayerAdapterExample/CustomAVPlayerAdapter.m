//
//  CustomAVPlayerAdapter.m
//  AVPlayerAdapterExample
//
//  Created by Enrique Alfonso Burillo on 02/07/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import "CustomAVPlayerAdapter.h"

@interface CustomAVPlayerAdapter()
@property (nonatomic, strong) NSNumber * lastContentPlayhead;
@end

@implementation CustomAVPlayerAdapter

- (void) fireSeekBegin:(NSDictionary<NSString *,NSString *> *)params convertFromBuffer:(bool)convertFromBuffer {
    if (self.plugin != nil && self.plugin.adsAdapter == nil && !(self.plugin.adsAdapter.flags.started || self.plugin.adsAdapter.flags.adInitiated)) {
        [super fireSeekBegin:params convertFromBuffer:convertFromBuffer];
    }
}

- (void) fireBufferBegin:(NSDictionary<NSString *,NSString *> *)params convertFromSeek:(bool)convertFromSeek {
    if (self.plugin != nil && self.plugin.adsAdapter == nil && !(self.plugin.adsAdapter.flags.started || self.plugin.adsAdapter.flags.adInitiated)) {
        [super fireBufferBegin:params convertFromSeek:convertFromSeek];
    }
}

- (NSNumber *) getPlayhead {
    if (self.plugin != nil && self.plugin.adsAdapter != nil && (self.plugin.adsAdapter.flags.started || self.plugin.adsAdapter.flags.adInitiated)) {
        return self.lastContentPlayhead == nil ? @0 : self.lastContentPlayhead;
    }
    return self.lastContentPlayhead = [super getPlayhead];
}

@end
