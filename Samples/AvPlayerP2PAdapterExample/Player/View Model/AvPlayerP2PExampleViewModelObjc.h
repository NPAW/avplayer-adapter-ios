//
//  PlayerViewModelObjc.h
//  AvPlayerP2PAdapterExample
//
//  Created by nice on 18/12/2019.
//  Copyright © 2019 npaw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AvPlayerP2PExampleViewModel.h"

@class MenuResourceOption;
@class MenuAdOption;

@interface AvPlayerExampleViewModelObjc : NSObject <AvPlayerExampleViewModel>

-(instancetype)initWith:(MenuResourceOption*)resource andAd:(MenuAdOption*)ad;
@end
