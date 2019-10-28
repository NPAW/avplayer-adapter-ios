//
//  YBAVPlayerP2PAdapter.h
//  YouboraAVPlayerAdapter
//
//  Created by Enrique Alfonso Burillo on 03/07/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import <YouboraAVPlayerAdapter/YouboraAVPlayerAdapter.h>
#if __has_include(<StreamrootSDK/StreamrootSDK-Swift.h>)
    #import <StreamrootSDK/StreamrootSDK-Swift.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface YBAVPlayerP2PAdapter : YBAVPlayerAdapter

#if __has_include(<StreamrootSDK/StreamrootSDK-Swift.h>)
    - (instancetype) initWithDnaClient:(nullable DNAClient *) dnaClient andPlayer:(nullable AVPlayer *) player;
#endif

@end

NS_ASSUME_NONNULL_END
