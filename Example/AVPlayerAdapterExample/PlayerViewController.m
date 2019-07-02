//
//  PlayerViewController.m
//  AVPlayerAdapterExample
//
//  Created by Joan on 20/04/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "PlayerViewController.h"
#import <YouboraConfigUtils/YouboraConfigUtils.h>
#import <YouboraAVPlayerAdapter/YouboraAVPlayerAdapter.h>

#import "CustomAVPlayerAdapter.h"

@import AVFoundation;
@import AVKit;

@interface PlayerViewController ()

@property (nonatomic, strong) AVPlayerViewController * playerViewController;

@property (nonatomic, strong) YBAVPlayerAdapter * adapter;
@property (nonatomic, strong) YBPlugin * youboraPlugin;

@property (nonatomic, strong) YBTimer * adsTimer;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // Set Youbora log level
    [YBLog setDebugLevel:YBLogLevelVerbose];
    
     [self.navigationController setHidesBarsOnTap:YES];
    
    __weak typeof(self) weakSelf = self;
    self.adsTimer = [[YBTimer alloc] initWithCallback:^(YBTimer *timer, long long diffTime) {
        if (weakSelf.youboraPlugin.adapter == nil) {
            weakSelf.adapter = [[CustomAVPlayerAdapter alloc] initWithPlayer:self.playerViewController.player];
            weakSelf.adapter.supportPlaylists = NO;
            [weakSelf.youboraPlugin setAdapter:self.adapter];
        }
        if (weakSelf.youboraPlugin.adsAdapter == nil) {
            [weakSelf.youboraPlugin setAdsAdapter:[[YBAVPlayerAdsAdapter alloc] initWithPlayer:weakSelf.playerViewController.player]];
            [weakSelf.playerViewController.player replaceCurrentItemWithPlayerItem: [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:@"https://video-dev.github.io/streams/x36xhzz/x36xhzz.m3u8"]]];
        } else {
            [weakSelf.youboraPlugin removeAdsAdapter];
            [weakSelf.playerViewController.player replaceCurrentItemWithPlayerItem: [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.resourceUrl]]];
        }
    } andInterval:15000];
    
    // Create Youbora plugin
    YBOptions * youboraOptions = [YouboraConfigManager getOptions]; // [YBOptions new];
    youboraOptions.offline = NO;
    youboraOptions.waitForMetadata = NO;
    self.youboraPlugin = [[YBPlugin alloc] initWithOptions:youboraOptions];
    
    // Send init - this creates a new view in Youbora
    [self.youboraPlugin fireInit];
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
    
    // Start playback
    [self.playerViewController.player play];
    [self.adsTimer start];
    
    // Uncomment this to test changing the rate
    //self.playerViewController.player.rate = 1.5;
}

- (void) startYoubora {
    //YBAVPlayerAdapter * adapter = [[YBAVPlayerAdapter alloc] initWithPlayer:self.playerViewController.player];
    YBAVPlayerAdsAdapter * adsAdapter = [[YBAVPlayerAdsAdapter alloc] initWithPlayer:self.playerViewController.player];
    //Uncomment this if you don't want to create a new view every time playerItem is changed
    //adapter.supportPlaylists = NO;
    //[self.youboraPlugin setAdapter:adapter];
    [self.youboraPlugin setAdsAdapter:adsAdapter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self.youboraPlugin removeAdsAdapter];
    [self.youboraPlugin removeAdapter];
    [super viewWillDisappear:animated];
}

-(void)appDidBecomeActive:(NSNotification*)notification {
    [self startYoubora];
    [self.playerViewController.player play];
}

-(void)appWillResignActive:(NSNotification*)notification {
    [self.youboraPlugin removeAdsAdapter];
    [self.youboraPlugin removeAdapter];
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
