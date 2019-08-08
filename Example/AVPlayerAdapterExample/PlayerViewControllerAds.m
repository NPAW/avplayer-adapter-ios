//
//  PlayerViewControllerAds.m
//  AVPlayerAdapterExample
//
//  Created by Enrique Alfonso Burillo on 08/08/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import "PlayerViewControllerAds.h"
#import <YouboraConfigUtils/YouboraConfigUtils.h>
#import <YouboraAVPlayerAdapter/YouboraAVPlayerAdapter.h>

#import "CustomAVPlayerAdapter.h"

@import AVFoundation;
@import AVKit;

@interface PlayerViewControllerAds ()

@property (nonatomic, strong) AVPlayerViewController * playerViewController;

@property (nonatomic, strong) YBAVPlayerAdapter * adapter;
@property (nonatomic, strong) YBPlugin * youboraPlugin;

@property (nonatomic, strong) YBTimer * adsTimer;

@property (nonatomic, strong) NSArray<NSNumber *> * adTimes;
@property (nonatomic, strong) NSMutableArray<NSValue *> * adTimesPlayed;
@property (nonatomic, assign) CMTime lastPlayhead;

@end

@implementation PlayerViewControllerAds

static void * const observationContext = (void *) &observationContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.adTimes = @[@0, @10, @15]; //When an ad is going to be played
    self.adTimesPlayed = [[NSMutableArray alloc] initWithArray:@[@NO, @NO, @NO]]; //If ad has been played
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // Set Youbora log level
    [YBLog setDebugLevel:YBLogLevelVerbose];
    
    //[self.navigationController setHidesBarsOnTap:YES];
    
    __weak typeof(self) weakSelf = self;
    
    // Create Youbora plugin
    YBOptions * youboraOptions = [YouboraConfigManager getOptions]; // [YBOptions new];
    youboraOptions.offline = NO;
    youboraOptions.waitForMetadata = NO;
    youboraOptions.accountCode = @"nicetest";
    youboraOptions.contentResource = @"http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8";
    self.youboraPlugin = [[YBPlugin alloc] initWithOptions:youboraOptions];
    
    // Send init - this creates a new view in Youbora
    //[self.youboraPlugin fireInit];
    // Video player controller
    self.playerViewController = [[AVPlayerViewController alloc] init];
    
    // Add view to the current screen
    [self addChildViewController:self.playerViewController];
    [self.view addSubview:self.playerViewController.view];
    
    // We use the playerView view as a guide for the video
    self.playerViewController.view.frame = self.view.frame;
    
    // Create AVPlayer
    self.playerViewController.player = [AVPlayer playerWithURL:[NSURL URLWithString:self.resourceUrl]];
    
    // As soon as we have the player instance, create an Adapter to listen for the player events
    [self startYoubora];
    //__weak typeof(self) weakSelf = self;
    
    self.adsTimer = [[YBTimer alloc] initWithCallback:^(YBTimer *timer, long long difftime) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        //[YBLog debug:@"PLAYHEAD: %lf", CMTimeGetSeconds(strongSelf.playerViewController.player.currentTime)];
        for (int k = 0; k < self.adTimes.count; k++) {
            if ([strongSelf.adTimesPlayed[k] isEqualToValue:@NO] && round(CMTimeGetSeconds(strongSelf.playerViewController.player.currentTime)) == round([strongSelf.adTimes[k] doubleValue]) && strongSelf.youboraPlugin.adsAdapter == nil) {
                strongSelf.adTimesPlayed[k] = @YES;
                [strongSelf.youboraPlugin setAdsAdapter:[[YBAVPlayerAdsAdapter alloc] initWithPlayer:weakSelf.playerViewController.player]];
                strongSelf.lastPlayhead = strongSelf.playerViewController.player.currentTime;
                [strongSelf.playerViewController.player replaceCurrentItemWithPlayerItem: [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:@"https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8"]]];
            }
            if (strongSelf.youboraPlugin.adsAdapter != nil && round(CMTimeGetSeconds(strongSelf.playerViewController.player.currentTime)) >= 15) {
                [strongSelf.youboraPlugin removeAdsAdapter];
                [strongSelf.playerViewController.player replaceCurrentItemWithPlayerItem: [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:strongSelf.resourceUrl]]];
                [strongSelf.playerViewController.player seekToTime:strongSelf.lastPlayhead];
            }
        }
    } andInterval:99]; //Check periodically if we have to play an ad and check if we have to add / remove the ad adapter (if ad has finished we HAVE TO remove the ad Adapter
    
    // Start playback
    [self.playerViewController.player play];
    [self.adsTimer start];
    
    // Uncomment this to test changing the rate
    //self.playerViewController.player.rate = 1.5;
}

- (void) startYoubora {
    YBAVPlayerAdapter * adapter = [[CustomAVPlayerAdapter alloc] initWithPlayer:self.playerViewController.player];
    adapter.supportPlaylists = NO; //Disable play lists since each ad is going to be a "new" AVPlayerItem
    
    [self.youboraPlugin setAdapter:adapter];
    //[self.youboraPlugin setAdsAdapter:adsAdapter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self.youboraPlugin removeAdsAdapter];
    [self.youboraPlugin removeAdapter];
    if (self.adsTimer != nil) {
        [self.adsTimer stop];
        self.adsTimer = nil;
    }
    [super viewWillDisappear:animated];
}

-(void)appDidBecomeActive:(NSNotification*)notification {
    //[self startYoubora];
    [self.playerViewController.player play];
}

-(void)appWillResignActive:(NSNotification*)notification {
    /*[self.youboraPlugin removeAdsAdapter];
     [self.youboraPlugin removeAdapter];
     if (self.adsTimer != nil) {
     [self.adsTimer stop];
     self.adsTimer = nil;
     }*/
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */ 

@end
