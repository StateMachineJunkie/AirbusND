//
//  FixedComponentsLayer.h
//  AirbusND
//
//  Created by Michael A. Crawford on 11/15/08.
//  Copyright 2008 Crawford Design Engineering, Inc. All rights reserved.
//

#import "NDLayer.h"

@class CATextLayer;
@class NavAid;
@class Waypoint;

@interface FixedComponentsLayer : NDLayer

@property (nonatomic) CGFloat glideSlopeDeviation;
@property (nonatomic) BOOL glideSlopeEnabled;
@property (nonatomic, readonly, retain) CATextLayer* navAid1TextLayer;
@property (nonatomic, readonly, retain) CATextLayer* navAid2TextLayer;
@property (nonatomic) int range;
@property (nonatomic, readonly, retain) CATextLayer* speedInfoTextLayer;
@property (nonatomic, readonly, retain) CATextLayer* waypointInfoTextLayer;

- (void)setGroundSpeed:(float)value;
- (void)setNavAid1Info:(NavAid*)info;
- (void)setNavAid2Info:(NavAid*)info;
- (void)setTrueAirSpeed:(float)value;
- (void)setWaypointInfo:(Waypoint*)info;
- (void)setWindDirection:(float)value;
- (void)setWindSpeed:(float)value;

@end
