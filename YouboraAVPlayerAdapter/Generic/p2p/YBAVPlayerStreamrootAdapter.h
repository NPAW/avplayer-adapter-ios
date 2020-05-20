//
//  YBAVPlayerStreamrootAdapter.h
//  YouboraAVPlayerAdapter
//
//  Created by nice on 09/01/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import "YBAVPlayerAdapter.h"

#if __has_include(<StreamrootSDK/StreamrootSDK.h>)
    #import <StreamrootSDK/StreamrootSDK.h>
#endif
#if __has_include(<StreamrootSDK/StreamrootSDK-Swift.h>)
    #import <StreamrootSDK/StreamrootSDK-Swift.h>
#endif


#if __has_include(<StreamrootSDK/StreamrootSDK.h>)

@interface YBAVPlayerStreamrootAdapter : YBAVPlayerAdapter

    - (instancetype) initWithDnaClient:(nullable DNAClient *) dnaClient andPlayer:(nullable AVPlayer *) player;

@end

#endif
