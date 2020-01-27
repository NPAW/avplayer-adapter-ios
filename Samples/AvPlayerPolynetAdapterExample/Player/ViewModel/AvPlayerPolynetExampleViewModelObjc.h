//
//  AvPlayerPolynetExampleViewModelObjc.h
//  AvPlayerPolynetAdapterExample
//
//  Created by nice on 09/01/2020.
//  Copyright © 2020 npaw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AvPlayerPolynetExampleViewModel.h"

@class MenuResourceOption;
@class MenuAdOption;

@interface AvPlayerExampleViewModelObjc : NSObject <AvPlayerExampleViewModel>

-(instancetype)initWith:(MenuResourceOption*)resource andAd:(MenuAdOption*)ad;

@end
