//
//  AttitudeIndicatorLayer.h
//  AirbusND
//
//  Created by Michael A. Crawford on 2/26/09.
//  Copyright 2009 Crawford Design Engineering, Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface AttitudeIndicatorLayer : CALayer
@property (nonatomic) CGFloat pitch;
@property (nonatomic) CGFloat roll;
@property (nonatomic) CGFloat yaw;
@end
