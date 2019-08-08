//
//  YBAVPlayerP2PAdapter.h
//  YouboraAVPlayerAdapter
//
//  Created by Enrique Alfonso Burillo on 03/07/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import <YouboraAVPlayerAdapter/YouboraAVPlayerAdapter.h>
#import <StreamrootSDK/StreamrootSDK-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBAVPlayerP2PAdapter : YBAVPlayerAdapter

- (instancetype) initWithDnaClient:(nullable DNAClient *) dnaClient andPlayer:(nullable AVPlayer *) player;

@end

NS_ASSUME_NONNULL_END
