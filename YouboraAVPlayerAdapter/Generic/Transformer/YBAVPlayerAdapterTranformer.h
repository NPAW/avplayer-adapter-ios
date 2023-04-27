//
//  YBAVPlayerAdapterTranformer.h
//  YouboraAVPlayerAdapter
//
//  Created by nice on 16/12/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>
#if SWIFT_PACKAGE
#import "YBAVPlayerAdapter.h"
#else
// How to define header search path for public header?
#import "../adapter/YBAVPlayerAdapter.h"
#endif

@interface YBAVPlayerAdapterSwiftTranformer : NSObject

+(YBPlayerAdapter<id>*)transformFromAdapter:(YBAVPlayerAdapter*)adapter;

@end
