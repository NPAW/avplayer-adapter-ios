//
//  AvPlayerExampleViewModel.h
//  Samples
//
//  Created by nice on 17/12/2019.
//  Copyright © 2019 npaw. All rights reserved.
//

#import <AVKit/AvKit.h>
#ifndef AvPlayerExampleViewModel_h
#define AvPlayerExampleViewModel_h

@protocol AvPlayerExampleViewModel

-(void)startYouboraWithPlayer:(AVPlayer* _Nullable)player;
-(void)setAdsAdapterWithPlayer:(AVPlayer* _Nullable)player;
-(void)adsDidFinish;
-(NSURL* _Nullable)getVideoUrl;
-(NSURL* _Nullable)getNextAd:(double)currentPlayhead;
-(Boolean)containAds;
-(void)stopYoubora;
@end

#endif /* AvPlayerExampleViewModel_h */
