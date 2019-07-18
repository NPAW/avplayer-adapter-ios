//
//  PlayerViewController.m
//  AVPlayerAdaptertvOSExample
//
//  Created by Enrique Alfonso Burillo on 21/08/2018.
//  Copyright © 2018 Enrique Alfonso Burillo. All rights reserved.
//

#import "PlayerViewController.h"

#import <YouboraAVPlayerAdapter/YouboraAVPlayerAdapter.h>

@import AVFoundation;
@import AVKit;

@interface PlayerViewController ()

@property (nonatomic, strong) AVPlayerViewController * playerViewController;

@property (nonatomic, strong) YBAVPlayerAdapter * adapter;
@property (nonatomic, strong) YBPlugin * youboraPlugin;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // Set Youbora log level
    [YBLog setDebugLevel:YBLogLevelVerbose];
    
    // Create Youbora plugin
    YBOptions * youboraOptions = [YBOptions new];
    youboraOptions.offline = NO;
    youboraOptions.accountCode = @"powerdev"; //Change this with your own account code
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
}

- (void) startYoubora {
    YBAVPlayerAdapter * adapter = [[YBAVPlayerAdapter alloc] initWithPlayer:self.playerViewController.player];
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

@end
