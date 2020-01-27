//
//  YBAVPlayerAdapterTranformer.m
//  YouboraAVPlayerAdapter
//
//  Created by nice on 16/12/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import "YBAVPlayerAdapterTranformer.h"

@implementation YBAVPlayerAdapterSwiftTranformer

+(YBPlayerAdapter<id>*)transformFromAdapter:(YBAVPlayerAdapter*)adapter { return adapter; }

@end
