//
//  YBAVPlayerAdapterTranformer.h
//  YouboraAVPlayerAdapter
//
//  Created by nice on 16/12/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBAVPlayerAdapter.h"

@interface YBAVPlayerAdapterSwiftTranformer : NSObject

+(YBPlayerAdapter<id>*)transformFromAdapter:(YBAVPlayerAdapter*)adapter;

@end
