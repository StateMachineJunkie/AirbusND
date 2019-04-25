//
//  NDCompassLayer.m
//  AirbusND
//
//  Created by Michael A. Crawford on 11/9/08.
//  Copyright 2008 Philips Medical Systems. All rights reserved.
//

#import "NDCompassLayer.h"
#import "NDUtilities.h"

@implementation NDCompassLayer

#pragma mark - NSObject Overrides

- (NSString*)description
{
    return @"Airbus Navigation Display Compass layer";
}

#pragma mark - Public Methods

- (void)setHeading:(CGFloat)newHeading
{
    //
    // Determine how fast to animate base on current heading and whether or not
    // we are current animating.  Question: How can I determine where we currently
    // are in the animation, if the animation is active?
    //
    [self animateHeadingUpdateFrom:self.heading to:newHeading];
    _heading = newHeading;
}

#pragma mark - Drawing Methods

- (void)animateHeadingUpdateFrom:(float)oldHeading to:(float)newHeading
{
    //
    // Convert headings to rotations so that we never rotate more than 180
    // degrees.  A value of 180 for the new heading is a special case; if the
    // old rotational value is negative then we should make the new rotational
    // value of 180 negatie in order to obtain the most efficient rotation.
    //
    CGFloat oldRotation, newRotation;
    
    oldRotation = HeadingToInverseRotation(oldHeading);
    newRotation = HeadingToInverseRotation(newHeading);
    
    NSLog(@"%f -> %f", oldRotation, newRotation);
    
    // create and configure required animation
    CABasicAnimation* animation     = [CABasicAnimation animation];
    animation.delegate              = self;
    animation.fillMode              = kCAFillModeForwards;
    animation.fromValue             = [NSNumber numberWithFloat:DegreesToRadians(oldRotation)];
    animation.keyPath               = kTransformRotationZ;
    animation.removedOnCompletion   = NO;
    animation.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.toValue               = [NSNumber numberWithFloat:DegreesToRadians(newRotation)];
    
    // add the animation to the layer (start animating)
    [self addAnimation:animation forKey:@"rotateAnimation"];
}

@end
