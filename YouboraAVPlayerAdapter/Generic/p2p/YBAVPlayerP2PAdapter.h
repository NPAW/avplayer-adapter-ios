//
//  YBAVPlayerP2PAdapter.h
//  YouboraAVPlayerAdapter
//
//  Created by Enrique Alfonso Burillo on 03/07/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import "YBAVPlayerAdapter.h"

#if __has_include(<StreamrootSDK/StreamrootSDK.h>)
    #import <StreamrootSDK/StreamrootSDK.h>
#endif
#if __has_include(<StreamrootSDK/StreamrootSDK-Swift.h>)
    #import <StreamrootSDK/StreamrootSDK-Swift.h>
#endif

#if __has_include(<StreamrootSDK/StreamrootSDK.h>)
__attribute__ ((deprecated)) DEPRECATED_MSG_ATTRIBUTE("This class is deprecated. Use YBAVPlayerStreamrootAdapter instead")
@interface YBAVPlayerP2PAdapter : YBAVPlayerAdapter
    - (instancetype) initWithDnaClient:(nullable DNAClient *) dnaClient andPlayer:(nullable AVPlayer *) player;
@end
#endif
