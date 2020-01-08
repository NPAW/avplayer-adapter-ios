//
//  YBAVPlayerAdsAdapterSwiftWrapper.h
//  YouboraAVPlayerAdapter
//
//  Created by Enrique Alfonso Burillo on 22/10/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import "YBAVPlayerAdsAdapter.h"
__attribute__ ((deprecated)) DEPRECATED_MSG_ATTRIBUTE("This class is deprecated. Use YBAVPlayerAdapterSwiftTranformer instead")
@interface YBAVPlayerAdsAdapterSwiftWrapper : NSObject

- (id) initWithPlayer:(NSObject*)player andPlugin:(YBPlugin*)plugin __deprecated_msg("Use initWithAdapter instead");;
- (id) initWithAdapter:(YBAVPlayerAdsAdapter *)adapter andPlugin:(YBPlugin*)plugin;
- (void) fireStart;
- (void) fireStop;
- (void) firePause;
- (void) fireResume;
- (void) fireJoin;

- (YBPlugin *) getPlugin;
- (YBAVPlayerAdsAdapter *) getAdapter;
- (void) removeAdapter;


@end
