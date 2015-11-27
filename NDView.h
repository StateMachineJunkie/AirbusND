//
//  NDView.h
//  Airbus Navigation Display
//
//  Created by Michael A. Crawford on 10/24/08.
//  Copyright 2008 Crawford Design Engineering. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ADF1Layer;
@class ADF2Layer;
@class AutopilotHeadingLayer;
@class CALayer;
@class CompassRoseLayer;
@class FixedComponentsLayer;
@class NAVLayer;
@class NDViewController;
@class SpeedInfoLayer;
@class VOR1Layer;
@class VOR2Layer;

@interface NDView : NSView
{
    CGFloat circumference;
    CGFloat diameter;
    CGFloat radius;
    
	ADF1Layer*              adf1Layer;
	ADF2Layer*              adf2Layer;
    AutopilotHeadingLayer*  autopilotHeadingLayer;
	CompassRoseLayer*       compassRoseLayer;
	FixedComponentsLayer*   fixedComponentsLayer;
    NAVLayer*               navLayer;
    SpeedInfoLayer*         speedInfoLayer;
    CALayer*                topLayer;
    VOR1Layer*              vor1Layer;
    VOR2Layer*              vor2Layer;

    IBOutlet NDViewController* controller;
}
@property CGFloat circumference;
@property CGFloat diameter;
@property CGFloat radius;
@property(readonly) CGFloat textSize;

@property(nonatomic, readonly, retain) CALayer* adf1Layer;
@property(nonatomic, readonly, retain) CALayer* adf2Layer;
@property(nonatomic, readonly, retain) CALayer* autopilotHeadingLayer;
@property(nonatomic, readonly, retain) CALayer* compassRoseLayer;
@property(nonatomic, readonly, retain) CALayer* fixedComponentsLayer;
@property(nonatomic, readonly, retain) CALayer* navLayer;
@property(nonatomic, readonly, retain) CALayer* speedInfoLayer;
@property(nonatomic, readonly, retain) CALayer* topLayer;
@property(nonatomic, readonly, retain) CALayer* vor1Layer;
@property(nonatomic, readonly, retain) CALayer* vor2Layer;

- (void)startAnimation;
- (void)stopAnimation;

@end
