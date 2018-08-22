//
//  ViewController.m
//  AVPlayerAdaptertvOSExample
//
//  Created by Enrique Alfonso Burillo on 21/08/2018.
//  Copyright © 2018 Enrique Alfonso Burillo. All rights reserved.
//

#import "ViewController.h"

#import "PlayerViewController.h"
#import "AVPlayerAdaptertvOSExample-Swift.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray<NSString *> * resources;
@property (assign) BOOL resourceSelected;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resourceSelected = NO;
    self.resources = @[@"http://aljazeera-ara-apple-live.adaptive.level3.net/apple/aljazeera/arabic/160.m3u8",
                       @"http://cdn3.viblast.com/streams/hls/airshow/playlist.m3u8",
                       @"http://fastly.nicepeopleatwork.com.global.prod.fastly.net/video/sintel-1024-surround.mp4",
                       @"http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8",
                       @"http://false.url.com/1234.mp4"];
    
    self.resourcesTableView.dataSource = self;
    self.resourcesTableView.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"BasicTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.resources objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.resources count];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.resourceSelected = YES;
    self.lblCurrentResource.text = [self.resources objectAtIndex:indexPath.row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayerObjCSegue"]) {
        
        PlayerViewController * playerViewController = segue.destinationViewController;
        playerViewController.resourceUrl = self.lblCurrentResource.text;
        
    }
    if ([segue.identifier isEqualToString:@"PlayerSwiftSegue"]) {
        
        PlayerViewControllerSwift * playerViewController = segue.destinationViewController;
        playerViewController.resourceUrl = self.lblCurrentResource.text;
    }
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (!self.resourceSelected) {
        UIAlertController * noResource = [UIAlertController
                                     alertControllerWithTitle:@"Resource"
                                     message:@"No resource selected"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* action = [UIAlertAction
                                   actionWithTitle:@"Ok"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //No action for now
                                   }];
        
        [noResource addAction:action];
        
        [self presentViewController:noResource animated:YES completion:nil];
    }
    return true;
}

@end
