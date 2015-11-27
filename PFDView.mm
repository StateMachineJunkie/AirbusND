//
//  PFDView.mm
//  AirbusND
//
//  Created by Michael A. Crawford on 2/19/09.
//  Copyright 2009 Crawford Design Engineering, Inc.. All rights reserved.
//

#import "PFDView.h"
#import <Foundation/NSString.h>
#import <QuartzCore/QuartzCore.h>
#import "CGColorHolder.h"
#import "NDUtilities.h"
#import "PFDDrawConstants.h"

@implementation PFDView

#pragma mark -
#pragma mark Initialization

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

#pragma mark -
#pragma mark Properties

@synthesize circumference;

- (NSString*)description
{
    return @"PFDView for Airbus Primary Flight Display";
}

@synthesize diameter;

- (CGFloat)textSize
{
    return ( radius * 0.10 );
}

@synthesize maskLayer;
@synthesize radius;
@synthesize topLayer;
    
#pragma mark -
#pragma mark Delegate Methods

- (void)awakeFromNib
{
	// init here, instead when doing CoreAnimation from a NIB
	self.layer = topLayer = [CALayer layer];
    [[self window] setContentAspectRatio:NSMakeSize(1.0, 1.0)];
    NSRect frame = [[self window] frame];
    frame.size.height = frame.size.width = MillimetersToPixels(94.0);
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
    self.layer.name = @"PFD-Root";
	self.layer.layoutManager = [CAConstraintLayoutManager layoutManager];
	self.layer.backgroundColor = [CGColorHolder black];
    self.layer.delegate = self;
    self.layer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
    self.layer.needsDisplayOnBoundsChange = YES;
    self.layer.bounds = CGRectMake(self.layer.bounds.origin.x,
                                   self.layer.bounds.origin.y,
                                   MillimetersToPixels(kViewWidth),
                                   MillimetersToPixels(kViewHeight));
    
    // initialize geometric properties for top layer
    diameter = MIN(self.layer.bounds.size.width * 0.9, self.layer.bounds.size.height * 0.9) * 0.70 /*75*/;
	radius = diameter / 2.0;
    circumference = M_PI * diameter;
    
    self.layer.cornerRadius = MillimetersToPixels(kViewCornerRadius);
    
	// allocate sub-layers that make up components of gauge
    maskLayer = [CALayer layer];
    maskLayer.delegate = self;
	//
	// Layers must be added in the proper order taking the painter's model into
	// account (add lowest layers first).  We must also be sure to make the in-
    // strumentation-needle layers relative to the compass-rose layer.
	//
	[self.layer addSublayer:maskLayer];
    
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
}

- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)ctx
{
    if ( self.topLayer == layer )
    {
        CGRect bounds = self.layer.bounds;
        
        NSLog(@"x = %f, y = %f, w = %f, h = %f",
              bounds.origin.x,
              bounds.origin.y,
              bounds.size.width,
              bounds.size.height);
        
        diameter = MIN(layer.bounds.size.width * 0.9, layer.bounds.size.height * 0.9) * 0.75;
        radius = diameter / 2.0;
        circumference = M_PI * diameter;
    }
    else if ( self.maskLayer == layer )
    {
        NSLog(@"x = %f, y = %f, w = %f, h = %f",
              self.layer.bounds.origin.x,
              self.layer.bounds.origin.y,
              self.layer.bounds.size.width,
              self.layer.bounds.size.height);
        //
        // Draw Primary Flight Display mask
        //
        CGContextSaveGState(ctx);
        CGContextSetStrokeColorWithColor(ctx, [CGColorHolder white]);
        CGContextSetLineWidth(ctx, 1.0);
        
        // airspeed tape
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(
            ctx,
            MillimetersToPixels(kSpeedTapeX),
            MillimetersToPixels(kSpeedTapeY));
        CGContextAddLineToPoint(
            ctx,
            MillimetersToPixels(kSpeedTapeX),
            MillimetersToPixels(kSpeedTapeY + kSpeedTapeHeight));
        CGContextAddLineToPoint(
            ctx,
            MillimetersToPixels(kSpeedTapeX + kSpeedTapeWidth), 
            MillimetersToPixels(kSpeedTapeY + kSpeedTapeHeight));
        CGContextAddLineToPoint(
            ctx,
            MillimetersToPixels(kSpeedTapeX + kSpeedTapeWidth), 
            MillimetersToPixels(kSpeedTapeY));
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathStroke);
        
        // heading indicator
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(
            ctx,
            MillimetersToPixels(kHeadingIndicatorX),
            MillimetersToPixels(kHeadingIndicatorY));
        CGContextAddLineToPoint(
            ctx,
            MillimetersToPixels(kHeadingIndicatorX),
            MillimetersToPixels(kHeadingIndicatorY + kHeadingIndicatorHeight));
        CGContextAddLineToPoint(
            ctx,
            MillimetersToPixels(kHeadingIndicatorX + kHeadingIndicatorWidth),
            MillimetersToPixels(kHeadingIndicatorY + kHeadingIndicatorHeight));
        CGContextAddLineToPoint(
            ctx,
            MillimetersToPixels(kHeadingIndicatorX + kHeadingIndicatorWidth),
            MillimetersToPixels(kHeadingIndicatorY));
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathStroke);

        // attitude indicator
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(
            ctx,
            MillimetersToPixels(kAttitudeIndicatorX),
            MillimetersToPixels(kAttitudeIndicatorY));
        CGContextAddLineToPoint(
            ctx,
            MillimetersToPixels(kAttitudeIndicatorX),
            MillimetersToPixels(kAttitudeIndicatorY + kAttitudeIndicatorHeight));
        CGContextAddArc(
            ctx,
            MillimetersToPixels(kAttitudeIndicatorX) + (MillimetersToPixels(kAttitudeIndicatorWidth) / 2.0),
            MillimetersToPixels(kAttitudeIndicatorY) + (MillimetersToPixels(kAttitudeIndicatorHeight) / 2.0),
            MillimetersToPixels(kAttitudeIndicatorRadius),
            DegreesToRadians(150.0),
            DegreesToRadians(30.0),
            kClockwise);
        CGContextAddLineToPoint(
            ctx,
            MillimetersToPixels(kAttitudeIndicatorX + kAttitudeIndicatorWidth),
            MillimetersToPixels(kAttitudeIndicatorY));
        CGContextAddArc(
            ctx,
            MillimetersToPixels(kAttitudeIndicatorX) + (MillimetersToPixels(kAttitudeIndicatorWidth) / 2.0),
            MillimetersToPixels(kAttitudeIndicatorY) + (MillimetersToPixels(kAttitudeIndicatorHeight) / 2.0),
            MillimetersToPixels(kAttitudeIndicatorRadius),
            DegreesToRadians(330.0),
            DegreesToRadians(210.0),
            kClockwise);
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathStroke);
        
        // altitude tape
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(
            ctx,
            MillimetersToPixels(kAltitudeTapeX),
            MillimetersToPixels(kAltitudeTapeBottomSegY));
        CGContextAddLineToPoint(
            ctx,
            MillimetersToPixels(kAltitudeTapeX),
            MillimetersToPixels(kAltitudeTapeBottomSegY + kAltitudeTapeBottomSegHeight));
        CGContextAddLineToPoint(
            ctx,
            MillimetersToPixels(kAltitudeTapeX + kAltitudeTapeWidth),
            MillimetersToPixels(kAltitudeTapeBottomSegY + kAltitudeTapeBottomSegHeight));
        CGContextAddLineToPoint(
            ctx,
            MillimetersToPixels(kAltitudeTapeX + kAltitudeTapeWidth),
            MillimetersToPixels(kAltitudeTapeBottomSegY));
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathStroke);
        
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(
             ctx,
             MillimetersToPixels(kAltitudeTapeX),
             MillimetersToPixels(kAltitudeTapeTopSegY));
        CGContextAddLineToPoint(
             ctx,
             MillimetersToPixels(kAltitudeTapeX),
             MillimetersToPixels(kAltitudeTapeTopSegY + kAltitudeTapeTopSegHeight));
        CGContextAddLineToPoint(
             ctx,
             MillimetersToPixels(kAltitudeTapeX + kAltitudeTapeWidth),
             MillimetersToPixels(kAltitudeTapeTopSegY + kAltitudeTapeTopSegHeight));
        CGContextAddLineToPoint(
             ctx,
             MillimetersToPixels(kAltitudeTapeX + kAltitudeTapeWidth),
             MillimetersToPixels(kAltitudeTapeTopSegY));
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathStroke);
        
        // virtical speed indicator
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(
            ctx,
            MillimetersToPixels(kVirticalSpeedIndicatorX),
            MillimetersToPixels(kVirticalSpeedIndicatorY));
        CGContextAddLineToPoint(
            ctx,
            MillimetersToPixels(kVirticalSpeedIndicatorX), 
            MillimetersToPixels(kVirticalSpeedIndicatorY + kVirticalSpeedIndicatorHeight));
        CGContextAddLineToPoint(
            ctx,
            MillimetersToPixels(kVirticalSpeedIndicatorX + kVirticalSpeedIndicatorWidth),
            MillimetersToPixels(kVirticalSpeedIndicatorY + kVirticalSpeedIndicatorHeight - kVirticalSpeedIndicatorOffset));
        CGContextAddLineToPoint(
            ctx,
            MillimetersToPixels(kVirticalSpeedIndicatorX + kVirticalSpeedIndicatorWidth),
            MillimetersToPixels(kVirticalSpeedIndicatorY + kVirticalSpeedIndicatorOffset));
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathStroke);
        CGContextRestoreGState(ctx);        
    }
}

#pragma mark -
#pragma mark Application Methods

- (void)startAnimation
{
    // TBD
}

- (void)stopAnimation
{
    // TBD
}

@end
