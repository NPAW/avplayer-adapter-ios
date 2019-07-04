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
#import <StreamrootSDK/StreamrootSDK-Swift.h>

@import AVFoundation;
@import AVKit;

@interface PlayerViewController () <DNAClientDelegate>

@property (nonatomic, strong) AVPlayerViewController * playerViewController;

@property (nonatomic, strong) YBAVPlayerAdapter * adapter;
@property (nonatomic, strong) YBPlugin * youboraPlugin;

@property (nonatomic, strong) DNAClient *dnaClient;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // Set Youbora log level
    [YBLog setDebugLevel:YBLogLevelVerbose];
    
     [self.navigationController setHidesBarsOnTap:YES];
    
    // Create Youbora plugin
    YBOptions * youboraOptions = [YouboraConfigManager getOptions]; // [YBOptions new];
    youboraOptions.offline = NO;
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
    
    NSURL *manifestUrl = [NSURL URLWithString: self.resourceUrl];
    NSError *error;
    // the streamroot key can be set in the config or in the mainPlist file
    self.dnaClient = [[[DNAClient.builder dnaClientDelegate: self] latency: 30]
                      start:manifestUrl error: &error];
    if (error || !self.dnaClient) {
        NSLog(@"error: %@", error);
    }
    
    NSURL *url = [[NSURL alloc] initWithString: self.dnaClient.manifestLocalURLPath];
    AVPlayerItem *playerItem =[[AVPlayerItem alloc] initWithURL: url];
    if (@available(iOS 10.2, *)) {
        playerItem.preferredForwardBufferDuration = self.dnaClient.bufferTarget;
    }
    
    self.playerViewController.player = [AVPlayer playerWithPlayerItem:playerItem];
    
    // As soon as we have the player instance, create an Adapter to listen for the player events
    [self startYoubora];
    
    // Start playback
    [self.playerViewController.player play];
    
    // Uncomment this to test changing the rate
    //self.playerViewController.player.rate = 1.5;
}

- (void) startYoubora {
    YBAVPlayerAdapter * adapter = [[YBAVPlayerP2PAdapter alloc] initWithDnaClient:self.dnaClient andPlayer:self.playerViewController.player];
    //Uncomment this if you don't want to create a new view every time playerItem is changed
    //adapter.supportPlaylists = NO;
    [self.youboraPlugin setAdapter:adapter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self.youboraPlugin removeAdapter];
    [super viewWillDisappear:animated];
}

-(void)appDidBecomeActive:(NSNotification*)notification {
    [self startYoubora];
    [self.playerViewController.player play];
}

-(void)appWillResignActive:(NSNotification*)notification {
    [self.youboraPlugin removeAdapter];
}

//MARK: - DNAClientDelegate

- (double)playbackTime {
    return CMTimeGetSeconds([self.playerViewController.player currentTime]);
}

- (NSArray<NSValue *> *)loadedTimeRanges {
    if (self.playerViewController.player == nil) {
        return [NSArray array];
    }
    
    NSMutableArray *timeRanges = [NSMutableArray array];
    for (NSValue *value in [[self.playerViewController.player currentItem] loadedTimeRanges]) {
        TimeRange *timeRange = [[TimeRange alloc] initWithRange:[value CMTimeRangeValue]];
        [timeRanges addObject:[[NSValue alloc] initWithTimeRange:timeRange]];
    }
    
    return timeRanges;
}

- (void)updatePeakBitRate:(double)bitRate {
    self.playerViewController.player.currentItem.preferredPeakBitRate = bitRate;
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
