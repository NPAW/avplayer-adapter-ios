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
@property (nonatomic, strong) id quartilePeriodicTimeObserver;
@property int lastQuartileSent;

@end

@implementation YBAVPlayerAdsAdapter

- (void) registerListeners {
    self.hasReallyStarted = false;
    [super registerListeners];
}

- (void) unregisterListeners {
    [super unregisterListeners];
    [self removeBoundaryTimeObserver];
}

- (void) fireStart:(NSDictionary<NSString *,NSString *> *)params {
    if (self.hasReallyStarted == false) {
        if ((self.plugin.adapter.player && self.player != self.plugin.adapter.player)) {
            [self addBoundaryTimeObserver];
        }
        self.hasReallyStarted = true;
        self.lastQuartileSent = 0;
        [self fireAdBreakStart];
        [super fireStart:params];
    }
}

- (void)fireStop:(NSDictionary<NSString *,NSString *> *)params {
    [super fireStop:params];
    [self fireAdBreakStop];
}

- (YBAdPosition) getPosition {
    if (self.plugin != nil) {
        if (self.plugin.adapter != nil) {
            return self.plugin.adapter.flags.joined ? YBAdPositionMid : YBAdPositionPre;
        }
        return YBAdPositionPre;
    }
    return YBAdPositionUnknown;
}

- (void) addBoundaryTimeObserver {
    
    // Divide the asset's duration into quarters.
    AVPlayer * avplayer = self.player;
    AVAsset * currentPlayerAsset = avplayer.currentItem.asset;
    float currentAssetDuration = CMTimeGetSeconds(currentPlayerAsset.duration);
    float interval = CMTimeGetSeconds(CMTimeMultiplyByFloat64(currentPlayerAsset.duration, .25));
    float currentTime = CMTimeGetSeconds(kCMTimeZero);
    NSMutableArray<NSValue *> * times = [[NSMutableArray alloc] init];
    
    // Calculate boundary times
    while(currentTime < currentAssetDuration) {
        currentTime += interval;
        [times addObject:[NSValue valueWithCMTime:CMTimeMakeWithSeconds(currentTime, 1)]];
    }
    
    __weak typeof(self) weakSelf = self;
    self.quartilePeriodicTimeObserver = [self.player addBoundaryTimeObserverForTimes:times queue:0 usingBlock:^ {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf fireQuartile: ++strongSelf.lastQuartileSent];
        }
    }];

}

- (void) removeBoundaryTimeObserver {
    if (self.quartilePeriodicTimeObserver) {
        [self.player removeTimeObserver:self.quartilePeriodicTimeObserver];
        self.quartilePeriodicTimeObserver = nil;
    }
}

@end
