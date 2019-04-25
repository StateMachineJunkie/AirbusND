//
//  NAVLayer.h
//  AirbusND
//
//  Created by Michael A. Crawford on 11/15/08.
//  Copyright 2008 Crawford Design Engineering, Inc. All rights reserved.
//

#import "NDCompassLayer.h"

@interface NAVLayer : NDCompassLayer

@property(nonatomic, readonly) id   context;
@property(nonatomic) float          deviation;
@property(nonatomic) bool           drawILSMode;

@end
