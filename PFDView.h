//
//  PFDView.h
//  AirbusND
//
//  Created by Michael A. Crawford on 2/19/09.
//  Copyright 2009 Crawford Design Engineering, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CALayer;
@class PFDViewController;

@interface PFDView : NSView
{
    CGFloat circumference;
    CGFloat diameter;
    CGFloat radius;
    
    CALayer* maskLayer;
    CALayer* topLayer;
    
    IBOutlet PFDViewController* controller;
}
@property CGFloat circumference;
@property CGFloat diameter;
@property(readonly, readonly, retain) CALayer* maskLayer;
@property CGFloat radius;
@property(readonly) CGFloat textSize;
@property(nonatomic, readonly, retain) CALayer* topLayer;

- (void)startAnimation;
- (void)stopAnimation;

@end
