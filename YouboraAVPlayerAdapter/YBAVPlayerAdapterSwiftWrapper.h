//
//  YBAVPlayerAdapterSwiftWrapper.h
//  YouboraAVPlayerAdapter
//
//  Created by Enrique Alfonso Burillo on 21/11/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBAVPlayerAdapter.h"

@interface YBAVPlayerAdapterSwiftWrapper : NSObject

- (id) initWithPlayer:(NSObject*)player andPlugin:(YBPlugin*)plugin;
- (id) initWithPlayer:(NSObject*)player andPlugin:(YBPlugin*)plugin withAutoJoinTime:(BOOL) autoJoinTime;
- (void) fireStart;
- (void) fireStop;
- (void) firePause;
- (void) fireResume;
- (void) fireJoin;

- (YBPlugin *) getPlugin;
- (YBAVPlayerAdapter *) getAdapter;
- (void) removeAdapter;

@end
