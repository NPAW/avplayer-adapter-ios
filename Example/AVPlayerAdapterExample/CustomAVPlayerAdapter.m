//
//  CustomAVPlayerAdapter.m
//  AVPlayerAdapterExample
//
//  Created by Enrique Alfonso Burillo on 02/07/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import "CustomAVPlayerAdapter.h"

@implementation CustomAVPlayerAdapter

- (void) fireSeekBegin:(NSDictionary<NSString *,NSString *> *)params convertFromBuffer:(bool)convertFromBuffer {
    if (self.plugin != nil && self.plugin.adsAdapter != nil && !(self.plugin.adsAdapter.flags.adInitiated || self.plugin.adsAdapter.flags.started)) {
        [super fireSeekBegin:params convertFromBuffer:convertFromBuffer];
    }
}

@end
