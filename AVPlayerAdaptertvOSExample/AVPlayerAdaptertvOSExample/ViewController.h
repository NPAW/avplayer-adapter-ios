//
//  ViewController.h
//  AVPlayerAdaptertvOSExample
//
//  Created by Enrique Alfonso Burillo on 21/08/2018.
//  Copyright © 2018 Enrique Alfonso Burillo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *resourcesTableView;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentResource;


@end

