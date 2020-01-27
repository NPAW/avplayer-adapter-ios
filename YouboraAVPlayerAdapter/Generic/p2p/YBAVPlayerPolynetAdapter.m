//
//  YBAVPlayerPolynetAdapter.m
//  YouboraAVPlayerAdapter
//
//  Created by nice on 09/01/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import "YBAVPlayerPolynetAdapter.h"

#if __has_include(<PolyNetSDK/PolyNetSDK.h>)

@interface YBAVPlayerPolynetAdapter ()

@property PolyNet *polynet;
@property (weak) id<PolyNetDelegate> polyNetDelegate;

@property (nonatomic, assign) NSNumber * lastP2PTraffic;
@property (nonatomic, assign) NSNumber * lastCDNTraffic;
@property (nonatomic, assign) BOOL isP2pEnabled;

@property (nonatomic, strong) NSMutableArray * fatalErrors;

@end

@implementation YBAVPlayerPolynetAdapter

@dynamic fatalErrors;

- (instancetype _Nonnull) initWithPolyNet:(nullable PolyNet *)polynet player:(nullable AVPlayer *)player {
    self = [super initWithPlayer:player];
    
    if (self) {
        self.lastP2PTraffic = nil;
        self.lastCDNTraffic = nil;
        self.isP2pEnabled = true;
        self.polynet = polynet;
        
        [self.fatalErrors removeObject:@-1008];
        
        if (self.polynet.delegate) {
            self.polyNetDelegate = self.polynet.delegate;
            self.polynet.delegate = self;
        } else {
            [YBLog error:@"Please instatiate Polynet delegate before init the adapter"];
        }
    }
    
    return self;
}

- (void)registerListeners {
    [super registerListeners];
    if (self.polynet.delegate) {
        self.polyNetDelegate = self.polynet.delegate;
        self.polynet.delegate = self;
    }
    
}

- (void)unregisterListeners {
    [super unregisterListeners];
    if (self.polyNetDelegate) {
        self.polynet.delegate = self.polyNetDelegate;
        self.polyNetDelegate = nil;
    }
}


#pragma mark - Getters

- (NSNumber *) getP2PTraffic {
    return self.lastP2PTraffic;
}

- (NSNumber *) getCdnTraffic {
    return self.lastCDNTraffic;
}

- (NSValue *) getIsP2PEnabled {
    return @(self.isP2pEnabled);
}

#pragma mark - PolyNetDelegate

- (void)polyNet:(PolyNet *)polyNet didUpdate:(PolyNetMetrics *)metrics {
    if (self.polyNetDelegate) { [self.polyNetDelegate polyNet:polyNet didUpdate:metrics]; }
    
    self.lastP2PTraffic = [NSNumber numberWithDouble: [metrics.accumulatedP2PDownThroughput doubleValue]];
    self.lastCDNTraffic = [NSNumber numberWithDouble: [metrics.accumulatedCDNDownThroughput doubleValue]];
}

- (void)polyNet:(PolyNet * _Nonnull)polyNet didFailWithError:(NSError * _Nonnull)error {
    if (self.polyNetDelegate) { [self.polyNetDelegate polyNet:polyNet didFailWithError:error]; }
}

@end

#endif
