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

@end

@implementation YBAVPlayerAdapterSwiftWrapper

- (id) initWithPlayer:(NSObject*)player{
    if (self = [super init]) {
        self.player = player;
    }
    return self;
}

- (YBAVPlayerAdapter *) getAdapter{
    AVPlayer* avPlayer = (AVPlayer*) self.player;
    return [[YBAVPlayerAdapter alloc] initWithPlayer:avPlayer];
}

@end
