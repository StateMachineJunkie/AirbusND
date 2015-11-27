//
//  CompassRoseLayer.m
//  AirbusND
//
//  Created by Michael A. Crawford on 11/15/08.
//  Copyright 2008 Crawford Design Engineering, Inc. All rights reserved.
//

#import "CompassRoseLayer.h"
#import "CGColorHolder.h"
#import "NDUtilities.h"

static NSString* myContext = @"AirbusND-CompassRose-Context";

@implementation CompassRoseLayer

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        self.name = @"compassRose";
    }
    
    return self;
}

#pragma mark - NSObject Overrides

- (NSString*)description
{
    return @"Airbus Navigation Display Compass-Rose layer";
}

#pragma mark -Public Methods

- (id)context
{
    return myContext;
}

#pragma mark - Drawing

- (void)animateHeadingUpdateFrom:(float)oldHeading to:(float)newHeading
{
    //
    // Convert headings to rotations so that we never rotate more than 180
    // degrees.  A value of 180 for the new heading is a special case; if the
    // old rotational value is negative then we should make the new rotational
    // value of 180 negatie in order to obtain the most efficient rotation.
    //
    CGFloat oldRotation, newRotation;

    if ( oldHeading > 180 )
    {
        oldRotation = HeadingToRotation(oldHeading);
    }
    else
    {
        oldRotation = oldHeading;
    }
    
    if ( newHeading > 180 )
    {
        newRotation = HeadingToRotation(newHeading);
    }
    else if ( 180 == newHeading && oldRotation < 0 )
    {
        newRotation = -180;
    }
    else
    {
        newRotation = newHeading;
    }

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

- (void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
    
	CGContextSaveGState(ctx);
	
	// set drawing properties
	CGContextSetLineWidth(ctx, 1.0);
	CGContextSetFillColorWithColor(ctx, [CGColorHolder white]);
	CGContextSetStrokeColorWithColor(ctx, [CGColorHolder white]);
	CGContextSelectFont(ctx, "Verdana", self.textSize, kCGEncodingMacRoman);
	
    //
	// Center and rotate the drawing context so that 0,0 is at the center and
    // zero degrees is at the top of the context.
    //
	CGContextTranslateCTM(ctx, CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextRotateCTM(ctx, DegreesToRadians(-90.0));
	
	// draw initial circle
	CGContextBeginPath(ctx);
	CGContextAddArc(ctx, 0.0, 0.0, self.radius, 0.0, DegreesToRadians(360.0), 0);
	
	// draw ticks around circle at five degree increments
	for ( CGFloat i = 0.0; i < 360.0; i += 5.0 )
	{
		CGPoint point = PointOnCircumference(i, self.radius);
		CGContextMoveToPoint(ctx, point.x, point.y);
		
		if ( ((int)i % 2) == 0 )
		{
			// draw ten degree tick
			point = PointOnCircumference(i, self.radius * 1.06);
            
			// draw tick value at 30 degree increments
			if ( ((int)i % 30) == 0 )
			{
				// text representing compass heading value
				CGFloat value = i * 0.10;
				NSString* s = [NSString stringWithFormat:@"%d", (int)value];
				char const* p = [s UTF8String];
                
                CGContextSaveGState(ctx);
				
				//
				// Draw invisibly first, in order to measure text output so that
				// it may be adjusted to be centered on the tick.
				//
				CGContextSetTextDrawingMode(ctx, kCGTextInvisible);
				CGContextShowTextAtPoint(ctx, 0, 0, p, strlen(p));
				CGPoint endingTextPosition = CGContextGetTextPosition(ctx);
				
				//
				// In order to draw text correctly it must be rotated and justified
				// according to is position on the compass-rose.
				//
				CGContextRotateCTM(ctx, DegreesToRadians(i - 90));
                CGContextTranslateCTM(ctx, 0.0, self.radius * 1.14);
                CGContextScaleCTM(ctx, -1.0, 1.0);
				
				CGContextSetTextDrawingMode(ctx, kCGTextFill);
                CGContextShowTextAtPoint(ctx, -endingTextPosition.x * 0.5, -self.textSize * 0.5, p, strlen(p));
                
                CGContextRestoreGState(ctx);
			}
		}
		else
		{
			// draw five degree tick
			point = PointOnCircumference(i, self.radius * 1.03);
		}
		
		CGContextAddLineToPoint(ctx, point.x, point.y);
	}
    
	// commit drawing, thus far
	CGContextDrawPath(ctx, kCGPathStroke);
    
	// draw half radius dashed-line circle
	CGContextBeginPath(ctx);
	CGFloat lengths[2] = { 8, 6 };
	CGContextSetLineDash(ctx, 0, lengths, 2);
	CGContextAddArc(ctx, 0.0, 0.0, self.radius * 0.5, 0.0, DegreesToRadians(360.0), 0);
	
	// committ drawing
	CGContextDrawPath(ctx, kCGPathStroke);
	
	CGContextRestoreGState(ctx);
}

@end
