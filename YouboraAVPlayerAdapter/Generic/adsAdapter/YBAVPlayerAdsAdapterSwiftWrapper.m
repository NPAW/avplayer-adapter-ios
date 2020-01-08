//
//  YBAVPlayerAdsAdapterSwiftWrapper.m
//  YouboraAVPlayerAdapter
//
//  Created by Enrique Alfonso Burillo on 22/10/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import "YBAVPlayerAdsAdapterSwiftWrapper.h"

@interface YBAVPlayerAdsAdapterSwiftWrapper()

@property(nonatomic,strong) NSObject* player;
@property(nonatomic,strong) YBPlugin* plugin;
@property(nonatomic,strong) YBAVPlayerAdsAdapter* adapter;

@end

@implementation YBAVPlayerAdsAdapterSwiftWrapper

- (id) initWithPlayer:(NSObject*)player andPlugin:(YBPlugin*)plugin{
    if (self = [super init]) {
        self.player = player;
        self.plugin = plugin;
    }
    [self initAdapterIfNecessary];
    return self;
}

- (id) initWithAdapter:(YBAVPlayerAdsAdapter *)adapter andPlugin:(YBPlugin*)plugin{
    if (self = [super init]) {
        self.adapter = adapter;
        self.plugin = plugin;
    }
    [self initAdapterIfNecessary];
    return self;
}

- (void) fireStart{
    [self initAdapterIfNecessary];
    [[self getAdapter] fireStart];
}

- (void) fireStop{
    if(self.plugin != nil){
        if(self.plugin.adsAdapter != nil){
            [self initAdapterIfNecessary];
            [[self getAdapter] fireStop];
            //[self.plugin removeAdapter];
        }
    }
    
}
- (void) firePause{
    [self initAdapterIfNecessary];
    [[self getAdapter] firePause];
}
- (void) fireResume{
    [self initAdapterIfNecessary];
    [[self getAdapter] fireResume];
}
- (void) fireJoin{
    [self initAdapterIfNecessary];
    [[self getAdapter] fireJoin];
}

- (YBAVPlayerAdsAdapter *) getAdapter{
    return (YBAVPlayerAdsAdapter *)self.adapter;
}

- (YBPlugin *) getPlugin{
    return self.plugin;
}

- (void) initAdapterIfNecessary{
    if(self.plugin.adsAdapter == nil){
        if(self.plugin != nil){
            YBAVPlayerAdsAdapter *adapter = nil;
            if ([self getAdapter] != nil) {
                adapter = [self getAdapter];
            }
            if (self.player != nil) {
                AVPlayer* avPlayer = (AVPlayer*) self.player;
                adapter = [[YBAVPlayerAdsAdapter alloc] initWithPlayer:avPlayer];
            }
            [self.plugin setAdsAdapter:adapter];
        }
    }
}

- (void) removeAdapter{
    [self.plugin removeAdapter];
}

@end
