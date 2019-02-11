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
@property(nonatomic, assign) BOOL autoJoinTime;

@end

@implementation YBAVPlayerAdapterSwiftWrapper

- (id) initWithPlayer:(NSObject*)player andPlugin:(YBPlugin*)plugin{
    return [self initWithPlayer:player andPlugin:plugin withAutoJoinTime:YES];
}

- (id) initWithPlayer:(NSObject*)player andPlugin:(YBPlugin*)plugin withAutoJoinTime:(BOOL) autoJoinTime{
    if (self = [super init]) {
        self.player = player;
        self.plugin = plugin;
        self.autoJoinTime = autoJoinTime;
    }
    [self initAdapterIfNecessary];
    return self;
}

- (void) fireStart{
    [self initAdapterIfNecessary];
    [self.plugin.adapter fireStart];
}

- (void) fireStop{
    if(self.plugin != nil){
        if(self.plugin.adapter != nil){
            [self initAdapterIfNecessary];
            [self.plugin.adapter fireStop];
            //[self.plugin removeAdapter];
        }
    }
    
}
- (void) firePause{
    [self initAdapterIfNecessary];
    [self.plugin.adapter firePause];
}
- (void) fireResume{
    [self initAdapterIfNecessary];
    [self.plugin.adapter fireResume];
}
- (void) fireJoin{
    [self initAdapterIfNecessary];
    [self.plugin.adapter fireJoin];
}

- (YBAVPlayerAdapter *) getAdapter{
    return (YBAVPlayerAdapter *)self.plugin.adapter;
}

- (YBPlugin *) getPlugin{
    return self.plugin;
}

- (void) initAdapterIfNecessary{
    if(self.plugin.adapter == nil){
        if(self.plugin != nil){
            AVPlayer* avPlayer = (AVPlayer*) self.player;
            YBAVPlayerAdapter *adapter = [[YBAVPlayerAdapter alloc] initWithPlayer:avPlayer];
            adapter.autoJoinTime = self.autoJoinTime;
            [self.plugin setAdapter:adapter];
        }
    }
}

- (void) removeAdapter{
    [self.plugin removeAdapter];
}

@end
