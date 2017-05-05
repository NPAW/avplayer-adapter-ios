//
//  ViewController.m
//  AVPlayerAdapterExample
//
//  Created by Joan on 13/04/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "ViewController.h"
#import <YouboraConfigUtils/YouboraConfigUtils.h>
#import "PlayerViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldResource;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * resources;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFieldResource.delegate = self;
    
    self.resources = @{@"Live HLS Aljazeera (L3)":@"http://aljazeera-ara-apple-live.adaptive.level3.net/apple/aljazeera/arabic/160.m3u8",
                       @"Live HLS Planes":@"http://cdn3.viblast.com/streams/hls/airshow/playlist.m3u8",
                       @"VoD mp4 Nice (Fastly)":@"http://fastly.nicepeopleatwork.com.global.prod.fastly.net/video/sintel-1024-surround.mp4",
                       @"VoD HLS Apple (ABR)":@"http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8",
                       @"Malformed url (error)":@"http://false.url.com/1234.mp4"};
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayerSegue"]) {
        
        PlayerViewController * playerViewController = segue.destinationViewController;
        playerViewController.resourceUrl = self.textFieldResource.text;
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)changeResourceClicked:(UIButton *)sender {
    // Show popup with a list of resources to pick
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Pick resource" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSString * key in self.resources) {
        NSString * value = self.resources[key];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@ - %@", key, value] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.textFieldResource.text = value;
        }];
        [alertController addAction:action];
    }
    
    // sourceView and sourceRect to support iPad
    alertController.popoverPresentationController.sourceView = sender;
    alertController.popoverPresentationController.sourceRect = sender.bounds;
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)youboraSettingsClicked:(id)sender {
    UIViewController * vc = [YouboraConfigViewController new];
    [[self navigationController] pushViewController:vc animated:YES];
}

@end
