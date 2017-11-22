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
    return self;
}

- (void) fireStart{
    [self initAdapterIfNecessary];
    [self.plugin.adapter fireStart];
}

- (void) fireStop{
    [self initAdapterIfNecessary];
    [self.plugin.adapter fireStop];
}
- (void) firePause{
    [self initAdapterIfNecessary];
    [self.plugin.adapter firePause];
}
- (void) fireResume{
    [self initAdapterIfNecessary];
    [self.plugin.adapter fireResume];
}

- (YBAVPlayerAdapter *) getAdapter{
    return self.adapter;
    /*AVPlayer* avPlayer = (AVPlayer*) self.player;
     return [[YBAVPlayerAdapter alloc] initWithPlayer:avPlayer];*/
}

- (YBPlugin *) getPlugin{
    return self.plugin;
    /*AVPlayer* avPlayer = (AVPlayer*) self.player;
     return [[YBAVPlayerAdapter alloc] initWithPlayer:avPlayer];*/
}

- (void) initAdapterIfNecessary{
    if(self.plugin.adapter == nil){
        if(self.plugin != nil){
            AVPlayer* avPlayer = (AVPlayer*) self.player;
            [self.plugin setAdapter:[[YBAVPlayerAdapter alloc] initWithPlayer:avPlayer]];
        }
    }
}

@end
