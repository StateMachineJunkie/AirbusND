//
//  NDView.m
//  Airbus Navigation Display view
//
//  Created by Michael A. Crawford on 10/24/08.
//  Copyright 2008 Philips Medical Systems. All rights reserved.
//

#import "NDView.h"
#import <Foundation/NSString.h>
#import <QuartzCore/QuartzCore.h>
#import "ADF1Layer.h"
#import "ADF2Layer.h"
#import "AutopilotHeadingLayer.h"
#import "CompassRoseLayer.h"
#import "CGColorHolder.h"
#import "FixedComponentsLayer.h"
#import "NAVLayer.h"
#import "NDUtilities.h"
#import "NDViewController.h"
#import "SpeedInfoLayer.h"
#import "VOR1Layer.h"
#import "VOR2Layer.h"

@implementation NDView

#pragma mark -
#pragma mark Properties

@synthesize adf1Layer;
@synthesize adf2Layer;
@synthesize autopilotHeadingLayer;
@synthesize circumference;
@synthesize compassRoseLayer;
@synthesize diameter;
@synthesize fixedComponentsLayer;
@synthesize navLayer;
@synthesize radius;
@synthesize speedInfoLayer;

- (CGFloat)textSize
{
    return ( radius * 0.10 );
}

- (NSString*)description
{
    NSRect frame = [self frame];
	NSRect bounds = [self bounds];
    return [NSString stringWithFormat:@"<NDView: %p> f=(%d,%d,%d,%d) b=(%d,%d,%d,%d)",
			self,
			(int)frame.origin.x,
			(int)frame.origin.y,
			(int)frame.size.width,
			(int)frame.size.height,
			(int)bounds.origin.x,
			(int)bounds.origin.y,
			(int)bounds.size.width,
			(int)bounds.size.height];
}

@synthesize topLayer;
@synthesize vor1Layer;
@synthesize vor2Layer;

#pragma mark -
#pragma mark Methods

#if 0
- (void)animationDidStop:(CABasicAnimation*)theAnimation finished:(BOOL)finished
{
    NSLog(@"animationDidStop: %@ %s", theAnimation, finished ? "finished" : "not finished");
    NSString* keyPath = theAnimation.keyPath;
    
    if ( finished )
    {
        [adf1Layer setValue:theAnimation.toValue forKeyPath:keyPath];
    }
    else
    {
        CALayer* p = [adf1Layer presentationLayer];
        adf1Layer.transform = p.transform;
    }
    [adf1Layer removeAnimationForKey:keyPath];
}
#endif

- (void)viewDidMoveToWindow
{
	// init here, instead when doing CoreAnimation from a NIB
	self.layer = topLayer = [CALayer layer];
    [[self window] setContentAspectRatio:NSMakeSize(1.0, kHeightToWidthRatio)];
    NSRect frame = [[self window] frame];
    frame.size.height = WidthToHeight(frame.size.width);
    [[self window] setFrame:frame display:YES];
    
    //
	// Because we are going to do a lot of our own event processing instead of
	// letting the framework do it for us, we want to be a layer-hosting-view.
	// The following line makes us a layer-hosting-view instead of a layer-
	// backed-view.
	//
	// Setting the wantsLayer property causes a new layer to be allocated and
	// associated with our view.  In order to avoid that hapennig and then turn-
	// ing around and throwing that layer away when we set the layer property,
	// we make sure we set the layer property first.
	//
	self.wantsLayer = YES;
    self.layer.name = @"ND-Root";
	self.layer.layoutManager = [CAConstraintLayoutManager layoutManager];
	self.layer.backgroundColor = [CGColorHolder black];
    self.layer.delegate = self;
    self.layer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
    self.layer.needsDisplayOnBoundsChange = YES;

    // initialize geometric properties for top layer
    diameter = MIN(self.layer.bounds.size.width * 0.9, self.layer.bounds.size.height * 0.9) * 0.70 /*75*/;
	radius = diameter / 2.0;
    circumference = M_PI * diameter;
    
    self.layer.cornerRadius = kCornerRadius;

	// allocate sub-layers that make up components of gauge
    adf1Layer               = [ADF1Layer new];
    adf2Layer               = [ADF2Layer new];
    autopilotHeadingLayer   = [AutopilotHeadingLayer new];
    compassRoseLayer        = [CompassRoseLayer new];
    fixedComponentsLayer    = [FixedComponentsLayer new];
    navLayer                = [NAVLayer new];
    speedInfoLayer          = [[SpeedInfoLayer alloc] initWithFrame:frame];
    vor1Layer               = [VOR1Layer new];
    vor2Layer               = [VOR2Layer new];

	//
	// Layers must be added in the proper order taking the painter's model into
	// account (add lowest layers first).  We must also be sure to make the in-
    // strumentation-needle layers relative to the compass-rose layer.
	//
    [compassRoseLayer addSublayer:autopilotHeadingLayer];
    [compassRoseLayer addSublayer:adf1Layer];
    [compassRoseLayer addSublayer:adf2Layer];
    [compassRoseLayer addSublayer:navLayer];
    [compassRoseLayer addSublayer:vor1Layer];
    [compassRoseLayer addSublayer:vor2Layer];
	[self.layer addSublayer:compassRoseLayer];
    
	// all compass-rose layers should have the same basic properties
    for ( CALayer* subLayer in compassRoseLayer.sublayers )
    {
		[subLayer setNeedsDisplay];
		subLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
		subLayer.needsDisplayOnBoundsChange = YES;
    }

    //
    // The text layers in the four corners of the ND display should be relative
    // to the fixed-components layer.
    //
    fixedComponentsLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
    
    // setup constraints for fixed-component layer
#if 0
    CAConstraint* minXConstraint = [CAConstraint constraintWithAttribute:kCAConstraintMinX
                                                              relativeTo:@"superlayer"
                                                               attribute:kCAConstraintMinX];
    
    CAConstraint* maxXConstraint = [CAConstraint constraintWithAttribute:kCAConstraintMaxX
                                                              relativeTo:@"superlayer"
                                                               attribute:kCAConstraintMaxX];

    CAConstraint* maxYConstraint = [CAConstraint constraintWithAttribute:kCAConstraintMaxY
                                                              relativeTo:@"superlayer"
                                                               attribute:kCAConstraintMaxY];

    CAConstraint* maxYMinus1Constraint = [CAConstraint constraintWithAttribute:kCAConstraintMaxY
                                                                    relativeTo:@"superlayer"
                                                                     attribute:kCAConstraintMaxY
                                                                        offset:-self.textSize];
#else
    CAConstraint* midXConstraint = [CAConstraint constraintWithAttribute:kCAConstraintMidX
                                                              relativeTo:@"superlayer"
                                                               attribute:kCAConstraintMidX];
    
    CAConstraint* midYConstraint = [CAConstraint constraintWithAttribute:kCAConstraintMidY
                                                              relativeTo:@"superlayer"
                                                               attribute:kCAConstraintMidY];
#endif
    speedInfoLayer.name = @"Speed Info";
#if 0
    [speedInfoLayer addConstraint:minXConstraint];
    [speedInfoLayer addConstraint:maxYConstraint];
#else
    [speedInfoLayer addConstraint:midXConstraint];
    [speedInfoLayer addConstraint:midYConstraint];
#endif
    [fixedComponentsLayer addSublayer:speedInfoLayer];
	[self.layer addSublayer:fixedComponentsLayer];

    // all fixed-component layers should have the same basic properties
    for ( CALayer* subLayer in fixedComponentsLayer.sublayers )
    {
		[subLayer setNeedsDisplay];
		subLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
		subLayer.needsDisplayOnBoundsChange = YES;
    }
    
    // give all sub-layers the same size, position, mask, etc.
	for ( CALayer* subLayer in self.layer.sublayers )
	{
		subLayer.bounds = CGRectMake(0.0f, 0.0f, NSWidth(self.bounds), NSHeight(self.bounds));
        subLayer.position = CGPointMake(NSMidX(self.bounds), NSMidY(self.bounds));
		subLayer.opacity = 1.0f;
		[subLayer setNeedsDisplay];
		subLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
		subLayer.needsDisplayOnBoundsChange = YES;
	}
    
    [self.layer setNeedsDisplay];
    
    //
    // Bind visual elements to model so we can see the changes over time.
    //
    
    // enable/disable ADF1
    [adf1Layer bind:@"visible"
           toObject:controller.model
        withKeyPath:@"adf1Enabled"
            options:nil];
    
    // set/get ADF1 heading
    [adf1Layer bind:@"heading"
           toObject:controller.model
        withKeyPath:@"adf1Heading"
            options:nil];

    // enable/disable ADF2
    [adf2Layer bind:@"visible"
           toObject:controller.model
        withKeyPath:@"adf2Enabled"
            options:nil];
  
    // set/get ADF2 heading
    [adf2Layer bind:@"heading"
           toObject:controller.model
        withKeyPath:@"adf2Heading"
            options:nil];

    // enable/disable auto-pilot heading indicator
    [autopilotHeadingLayer bind:@"visible"
                       toObject:controller.model
                    withKeyPath:@"autopilotHeadingModeEnabled"
                        options:nil];
    
    // set/get auto-pilot heading
    [autopilotHeadingLayer bind:@"heading"
                       toObject:controller.model
                    withKeyPath:@"autopilotHeading"
                        options:nil];
    
    // set/get compass-rose heading
    [compassRoseLayer bind:@"heading"
                  toObject:controller.model
               withKeyPath:@"compassHeading"
                   options:nil];

    // set/get glide-slope deviation
    [fixedComponentsLayer bind:@"glideSlopeDeviation"
                      toObject:controller.model
                   withKeyPath:@"glideSlopeDeviation"
                       options:nil];
    
    // enable/disable glide-slope deviation indicator
    [fixedComponentsLayer bind:@"glideSlopeEnabled"
                      toObject:controller.model
                   withKeyPath:@"glideSlopeEnabled"
                       options:nil];
    
    // set/get NAV Course heading
    [navLayer bind:@"heading"
          toObject:controller.model
       withKeyPath:@"navCourse"
           options:nil];
    
    // set/get NAV Course deviation
    [navLayer bind:@"deviation"
          toObject:controller.model
       withKeyPath:@"navCourseDeviation"
           options:nil];

    // set/get NAV mode
    [navLayer bind:@"drawILSMode"
          toObject:controller.model
       withKeyPath:@"navMode"
           options:nil];

    // set/get ND range
    [fixedComponentsLayer bind:@"range"
                      toObject:controller.model
                   withKeyPath:@"range"
                       options:nil];
    
    // enable/disable VOR1
    [vor1Layer bind:@"visible"
           toObject:controller.model
        withKeyPath:@"vor1Enabled"
            options:nil];
    
    // set/get VOR1 heading
    [vor1Layer bind:@"heading"
           toObject:controller.model
        withKeyPath:@"vor1Heading"
            options:nil];
    
    // enable/disable VOR2
    [vor2Layer bind:@"visible"
           toObject:controller.model
        withKeyPath:@"vor2Enabled"
            options:nil];
    
    // set/get VOR2 heading
    [vor2Layer bind:@"heading"
           toObject:controller.model
        withKeyPath:@"vor2Heading"
            options:nil];
}

- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)ctx
{
    NSAssert(topLayer == layer, @"We should only be getting delegate calls for the top layer");

    // update geometric properties for top layer and all sub-layers
    diameter = MIN(layer.bounds.size.width * 0.9, layer.bounds.size.height * 0.9) * 0.75;
    radius = diameter / 2.0;
    circumference = M_PI * diameter;
    layer.cornerRadius = kCornerRadius;
}

- (void)startAnimation
{
	// animate the compass-rose
	CABasicAnimation* compassRoseAnimation  = [CABasicAnimation animation];
    compassRoseAnimation.autoreverses       = YES;
	compassRoseAnimation.duration           = DegreesToDuration(45.0, 20.0);
	compassRoseAnimation.fromValue          = [NSNumber numberWithFloat: 0.0];
	compassRoseAnimation.keyPath            = @"transform.rotation.z";
	compassRoseAnimation.repeatDuration     = 30.0;
	compassRoseAnimation.timingFunction     = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	compassRoseAnimation.toValue            = [NSNumber numberWithFloat: DegreesToRadians(45.0)];
	
	// add the animation to the layer (start animating)
	[compassRoseLayer addAnimation:compassRoseAnimation forKey:@"rotateAnimation"];
    
    // animate the ADF1 needle
    CABasicAnimation* adf1Animation = [CABasicAnimation animation];
    adf1Animation.autoreverses      = YES;
    adf1Animation.duration          = DegreesToDuration(320.0, 20.0);
    adf1Animation.fromValue         = [NSNumber numberWithFloat:0.0];
    adf1Animation.keyPath           = @"transform.rotation.z";
    adf1Animation.repeatDuration    = 30.0;
    adf1Animation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    adf1Animation.toValue           = [NSNumber numberWithFloat:DegreesToRadians(-320)];
    
    // add the animation to the layer (start animating)
    [adf1Layer addAnimation:adf1Animation forKey:@"rotateAnimation"];
	
    // animate the ADF2 needle
    CABasicAnimation* adf2Animation = [CABasicAnimation animation];
    adf2Animation.autoreverses      = YES;
    adf2Animation.duration          = DegreesToDuration(270.0, 20.0);
    adf2Animation.fromValue         = [NSNumber numberWithFloat:DegreesToRadians(0)];
    adf2Animation.keyPath           = @"transform.rotation.z";
    adf2Animation.repeatDuration    = 30.0;
    adf2Animation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    adf2Animation.toValue           = [NSNumber numberWithFloat:DegreesToRadians(270)];
    
    // add the animation to the layer (start animating)
    [adf2Layer addAnimation:adf2Animation forKey:@"rotateAnimation"];
    
    // animate the heading triangle
    CABasicAnimation* headingAnimation  = [CABasicAnimation animation];
    headingAnimation.autoreverses       = YES;
    headingAnimation.duration           = DegreesToDuration(98.0, 20.0);
    headingAnimation.fromValue          = [NSNumber numberWithFloat:DegreesToRadians(0)];
    headingAnimation.keyPath            = @"transform.rotation.z";
    headingAnimation.repeatDuration     = 30.0;
    headingAnimation.timingFunction     = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    headingAnimation.toValue            = [NSNumber numberWithFloat:DegreesToRadians(-98)];
    
    // add the animation to the layer (start animating)
    [autopilotHeadingLayer addAnimation:headingAnimation forKey:@"rotateAnimation"];
}

- (void)stopAnimation
{
    [adf1Layer removeAllAnimations];
    [adf2Layer removeAllAnimations];
    [autopilotHeadingLayer removeAllAnimations];
    [compassRoseLayer removeAllAnimations];
}

@end
