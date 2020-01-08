//
//  YBAVPlayerAdapterSwiftWrapper.h
//  YouboraAVPlayerAdapter
//
//  Created by Enrique Alfonso Burillo on 21/11/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBAVPlayerAdapter.h"
__attribute__ ((deprecated)) DEPRECATED_MSG_ATTRIBUTE("This class is deprecated. Use YBAVPlayerAdapterSwiftTranformer instead")
@interface YBAVPlayerAdapterSwiftWrapper : NSObject

- (id) initWithPlayer:(NSObject*)player andPlugin:(YBPlugin*)plugin __deprecated_msg("Use initWithAdapter instead");;
- (id) initWithAdapter:(YBAVPlayerAdapter *)adapter andPlugin:(YBPlugin*)plugin;
- (void) fireStart;
- (void) fireStop;
- (void) firePause;
- (void) fireResume;
- (void) fireJoin;

- (YBPlugin *) getPlugin;
- (YBAVPlayerAdapter *) getAdapter;
- (void) removeAdapter;

@end
