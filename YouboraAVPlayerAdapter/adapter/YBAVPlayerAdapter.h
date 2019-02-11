//
//  YBAVPlayerAdapter.h
//  YouboraAVPlayerAdapter
//
//  Created by Joan on 13/04/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YouboraLib/YouboraLib.h>

@class AVPlayer;

@interface YBAVPlayerAdapter : YBPlayerAdapter<AVPlayer *>

+ (YBAVPlayerAdapter*) instantiateWithPlayer:(AVPlayer*) player;

/// If changing current item creates new view, by default it's YES
@property (nonatomic, assign) BOOL supportPlaylists;

/// If the content loads but the metadata have not come through, by default it's YES
@property (nonatomic, assign) BOOL autoJoinTime;

@end
