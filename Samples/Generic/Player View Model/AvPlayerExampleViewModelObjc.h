//
//  AvPlayerExampleViewModelObjc.h
//  Samples
//
//  Created by nice on 17/12/2019.
//  Copyright © 2019 npaw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AvPlayerExampleViewModel.h"

@class MenuResourceOption;
@class MenuAdOption;

@interface AvPlayerExampleViewModelObjc : NSObject <AvPlayerExampleViewModel>

-(instancetype)initWith:(MenuResourceOption*)resource andAd:(MenuAdOption*)ad;

@end
