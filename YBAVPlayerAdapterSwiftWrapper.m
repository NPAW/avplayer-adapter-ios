//
//  YBAVPlayerAdapterSwiftWrapper.m
//  YouboraAVPlayerAdapter
//
//  Created by Enrique Alfonso Burillo on 21/11/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBAVPlayerAdapterSwiftWrapper.h"

@interface YBAVPlayerAdapterSwiftWrapper ()

@property(nonatomic,strong) NSObject* player;
@property(nonatomic,strong) YBPlugin* plugin;
@property(nonatomic,strong) YBAVPlayerAdapter* adapter;

@end

@implementation YBAVPlayerAdapterSwiftWrapper

- (id) initWithPlayer:(NSObject*)player andPlugin:(YBPlugin*)plugin{
    if (self = [super init]) {
        self.player = player;
        self.plugin = plugin;
    }
    [self initAdapterIfNecessary];
    return self;
}

- (id) initWithAdapter:(YBAVPlayerAdapter *)adapter andPlugin:(YBPlugin*)plugin{
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
        if(self.plugin.adapter != nil){
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

- (YBAVPlayerAdapter *) getAdapter{
    return (YBAVPlayerAdapter *)self.adapter;
}

- (YBPlugin *) getPlugin{
    return self.plugin;
}

- (void) initAdapterIfNecessary{
    if(self.plugin.adapter == nil){
        if(self.plugin != nil){
            YBAVPlayerAdapter *adapter = nil;
            if ([self getAdapter] != nil) {
                adapter = [self getAdapter];
            }
            if (self.player != nil) {
                AVPlayer* avPlayer = (AVPlayer*) self.player;
                adapter = [[YBAVPlayerAdapter alloc] initWithPlayer:avPlayer];
            }
            [self.plugin setAdapter:adapter];
        }
    }
}

- (void) removeAdapter{
    [self.plugin removeAdapter];
}

@end
