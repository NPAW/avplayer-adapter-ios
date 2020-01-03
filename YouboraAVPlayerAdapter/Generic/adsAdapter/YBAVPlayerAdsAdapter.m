//
//  YBAVPlayerAdsAdapter.m
//  YouboraAVPlayerAdapter
//
//  Created by Enrique Alfonso Burillo on 02/07/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import "YBAVPlayerAdsAdapter.h"
#import <YouboraLib/YouboraLib-Swift.h>

@interface YBAVPlayerAdsAdapter()

@property (nonatomic, assign) BOOL hasReallyStarted;

@end

@implementation YBAVPlayerAdsAdapter

- (void) registerListeners {
    self.hasReallyStarted = false;
    [super registerListeners];
}

- (void) fireStart:(NSDictionary<NSString *,NSString *> *)params {
    if (self.hasReallyStarted == false) {
        self.hasReallyStarted = true;
        [super fireStart:params];
    }
}

-(YBAdPosition) getPosition {
    if (self.plugin != nil) {
        if (self.plugin.adapter != nil) {
            return self.plugin.adapter.flags.joined ? YBAdPositionMid : YBAdPositionPre;
        }
        return YBAdPositionPre;
    }
    return YBAdPositionUnknown;
}

@end
