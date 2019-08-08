//
//  PlayerViewControllerAds.h
//  AVPlayerAdapterExample
//
//  Created by Enrique Alfonso Burillo on 08/08/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface PlayerViewControllerAds : UIViewController

/**
 * The resource url to load onto the player.
 *
 * This should be set right before pushing the ViewController. For instance in the
 * prepareForSegue method
 */
@property (nonatomic, strong) NSString * resourceUrl;


@end

NS_ASSUME_NONNULL_END
