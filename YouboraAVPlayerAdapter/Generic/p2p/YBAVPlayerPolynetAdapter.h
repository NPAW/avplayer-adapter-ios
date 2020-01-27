//
//  YBAVPlayerPolynetAdapter.h
//  YouboraAVPlayerAdapter
//
//  Created by nice on 09/01/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import "YBAVPlayerAdapter.h"

#if __has_include(<PolyNetSDK/PolyNetSDK.h>)
#import <PolyNetSDK/PolyNetSDK.h>

@interface YBAVPlayerPolynetAdapter : YBAVPlayerAdapter <PolyNetDelegate>

- (instancetype _Nonnull) initWithPolyNet:(nullable PolyNet *)polynet player:(nullable AVPlayer *)player;

@end
#endif
