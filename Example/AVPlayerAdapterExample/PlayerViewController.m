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
    YBOptions * youboraOptions = [YouboraConfigManager getOptions]; // [YBOptions new];
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
    //YBAVPlayerAdapter * adapter = [[YBAVPlayerAdapter alloc] initWithPlayer:self.playerViewController.player];
    self.adapter = 
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
