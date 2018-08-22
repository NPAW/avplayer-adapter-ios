//
//  PlayerViewController.h
//  AVPlayerAdaptertvOSExample
//
//  Created by Enrique Alfonso Burillo on 21/08/2018.
//  Copyright © 2018 Enrique Alfonso Burillo. All rights reserved.
//

#import "ViewController.h"

@interface PlayerViewController : ViewController
/**
 * The resource url to load onto the player.
 *
 * This should be set right before pushing the ViewController. For instance in the
 * prepareForSegue method
 */
@property (nonatomic, strong) NSString * resourceUrl;
@end
