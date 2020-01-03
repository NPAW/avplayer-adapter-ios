//
//  YBAVPlayerP2PAdapter.m
//  YouboraAVPlayerAdapter
//
//  Created by Enrique Alfonso Burillo on 03/07/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import "YBAVPlayerP2PAdapter.h"

#if __has_include(<StreamrootSDK/StreamrootSDK.h>)
@interface YBAVPlayerP2PAdapter()

@property (nonatomic, assign) NSNumber * lastP2PTraffic;
@property (nonatomic, assign) NSNumber * lastCDNTraffic;
@property (nonatomic, assign) NSNumber * lastUploadTraffic;
@property (nonatomic, assign) BOOL isP2pEnabled;

@property (nonatomic, strong) YBTimer * statsTimer;

@property (nonatomic, strong) DNAClient * dnaClient;

@end

@implementation YBAVPlayerP2PAdapter

- (instancetype) initWithDnaClient:(nullable DNAClient *) dnaClient andPlayer:(nullable AVPlayer *) player {
    if (self = [super initWithPlayer:player]) {
        self.lastP2PTraffic = nil;
        self.lastCDNTraffic = nil;
        self.lastUploadTraffic = nil;
        self.isP2pEnabled = true;
        
        self.dnaClient = dnaClient;
    }
    
    return self;
}

- (void) fireStart:(NSDictionary<NSString *,NSString *> *)params {
    self.statsTimer = [[YBTimer alloc] initWithCallback:^(YBTimer * timer, long long diffTime) {
        [self.dnaClient stats:^(NSDictionary<NSString *, id> * stats) {
            [YBLog debug:[stats description]];
            [YBLog debug:@"p2p: %l cdn: %l upload: %l", (long)stats[@"p2p"], (long)stats[@"cdn"], (long)stats[@"upload"]];
            self.lastP2PTraffic = (NSNumber *)stats[@"p2p"];
            self.lastCDNTraffic = (NSNumber *)stats[@"cdn"];
            self.lastUploadTraffic = (NSNumber *)stats[@"upload"];
            
        }];
    } andInterval:1000];
    [self.statsTimer start];
    [super fireStart:params];
}

- (void) fireStop:(NSDictionary<NSString *,NSString *> *)params {
    [super fireStop:params];
    [self.statsTimer stop];
    self.statsTimer = nil;
}

//Getter methods

- (NSNumber *) getP2PTraffic {
    return self.lastP2PTraffic;
}

- (NSNumber *) getCdnTraffic {
    return self.lastCDNTraffic;
}

- (NSNumber *) getUploadTraffic {
    return self.lastUploadTraffic;
}

- (NSValue *) getIsP2PEnabled {
    return @(self.isP2pEnabled);
}

@end
#endif
