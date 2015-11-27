//
//  NDCompassLayer.h
//  AirbusND
//
//  Created by Michael A. Crawford on 11/9/08.
//  Copyright 2008 Crawford Design Engineering, Inc. All rights reserved.
//

#import "NDLayer.h"

@interface NDCompassLayer : NDLayer

@property (nonatomic) CGFloat heading;

- (void)animateHeadingUpdateFrom:(float)oldHeading to:(float)newHeading;

@end
