//
//  YBAVPlayerAdapter.h
//  YouboraAVPlayerAdapter
//
//  Created by Joan on 13/04/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
#import <YouboraLib/YouboraLib.h>

@interface YBAVPlayerAdapter : YBPlayerAdapter<AVPlayer *>

+ (YBAVPlayerAdapter*) instantiateWithPlayer:(AVPlayer*) player;

- (void) fireStop;

/// If changing current item creates new view, by default it's YES
@property (nonatomic, assign) BOOL supportPlaylists;

/// If the content loads but the metadata have not come through, by default it's YES
@property (nonatomic, assign) BOOL autoJoinTime DEPRECATED_MSG_ATTRIBUTE("This property will be removed in future releases");

- (void) addFatalErrors:(NSMutableArray*) fatalErrors;

@end
