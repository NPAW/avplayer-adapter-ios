//
//  AvPlayerPolynetExampleViewModel.h
//  AvPlayerPolynetAdapterExample
//
//  Created by nice on 09/01/2020.
//  Copyright © 2020 npaw. All rights reserved.
//

#ifndef AvPlayerPolynetExampleViewModel_h
#define AvPlayerPolynetExampleViewModel_h

@import PolyNetSDK;
#import <AVKit/AvKit.h>

@protocol AvPlayerExampleViewModel

-(void)startYouboraWithPlayer:(AVPlayer* _Nullable)player polynet:(PolyNet* _Nullable)polynet andPolynetDelegate:(id <PolyNetDelegate> _Nullable)polynetDelegate;
-(void)setAdsAdapterWithPlayer:(AVPlayer* _Nullable)player;
-(void)adsDidFinish;
-(NSURL* _Nullable)getVideoUrl;
-(NSURL* _Nullable)getNextAd:(double)currentPlayhead;
-(Boolean)containAds;
-(void)stopYoubora;

@end


#endif /* AvPlayerPolynetExampleViewModel_h */
