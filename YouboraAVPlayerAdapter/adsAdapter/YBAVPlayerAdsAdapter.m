//
//  YBAVPlayerAdsAdapter.m
//  YouboraAVPlayerAdapter
//
//  Created by Enrique Alfonso Burillo on 02/07/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import "YBAVPlayerAdsAdapter.h"

@implementation YBAVPlayerAdsAdapter


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
