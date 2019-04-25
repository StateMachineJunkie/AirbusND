//
//  NAVLayer.mm
//  AirbusND
//
//  Created by Michael A. Crawford on 11/15/08.
//  Copyright 2008 Crawford Design Engineering, Inc. All rights reserved.
//

#import "NAVLayer.h"
#import "CGColorHolder.h"
#import "NDUtilities.h"

//
// The lateral and localizer deviation ratios are calculated based on the
// proportion of the radius of the Navigation Display used for placing the
// deviation-scale-circles and the number of degrees represented for each
// deviation-scale-circle.  The circles are placed at 1/4 increments from the
// center of the display and each circle represents 5.0 degrees and 1.25 degrees
// of deviation, respectively.  Thus:
//
//      0.25 / 5.0  = 0.05
//      0.25 / 1.25 = 0.2
//
float const kLateralDeviationRatio = 0.05; 
float const kLocalizerDeviationRatio = 0.2;

static NSString* myContext = @"AirbusND-NAV-Context";

@implementation NAVLayer

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        self.name = @"NAV";
    }
    
    return self;
}

#pragma mark - NSObject Overrides

- (NSString*)description
{
    return @"Airbus Navigation Display NAV layer";
}

#pragma mark - Public Methods

- (id)context
{
    return myContext;
}

- (void)setDeviation:(float)newDeviation
{
    //
    // The course-deviation needle needs to be retrawn in a new position.  Up-
    // date the position and trigger a drawInContext event.
    //
    _deviation = newDeviation;
    [self setNeedsDisplay];
}


@synthesize drawILSMode;

#pragma mark - Drawing

- (void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
    
	CGContextSaveGState(ctx);
    
    // set drawing properties
    CGContextSetLineWidth(ctx, 1.0);
    
    if ( drawILSMode )
    {
        CGContextSetStrokeColorWithColor(ctx, [CGColorHolder magenta]);
    }
    else
    {
        CGContextSetStrokeColorWithColor(ctx, [CGColorHolder cyan]);
    }
    
    //
	// Center and rotate the drawing context so that 0,0 is at the center and
    // zero degrees is at the top of the context.
    //
    CGContextTranslateCTM(ctx, CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextRotateCTM(ctx, DegreesToRadians(-90.0));

    //
    // Draw NAV course needle.  The arrow-heads of this needle have a width that is the
    // same as the width of the ADF2 needle.
    //
    CGFloat adf2Width = self.circumference / 36.0;
    CGContextBeginPath(ctx);
    
    // center/forward segment
    CGContextMoveToPoint(ctx, self.radius, 0.0);
    CGContextAddLineToPoint(ctx, self.radius * 0.5, 0.0);
    
    // center/aft segment
    CGContextMoveToPoint(ctx, -self.radius, 0.0);
    CGContextAddLineToPoint(ctx, -(self.radius * 0.5), 0.0);
    
    // cross segment
    CGContextMoveToPoint(ctx, self.radius * 0.667, adf2Width * 0.5);
    CGContextAddLineToPoint(ctx, self.radius * 0.667, -(adf2Width * 0.5));
    
    //
    // Draw VOR/ILS course deviation bar (center cegment)
    //
    float deviationOffsetY;
    
    if ( drawILSMode )
    {
        if ( self.deviation > 2.5 )
        {
            self.deviation = 2.5;
        }
        else if ( self.deviation < -2.5 )
        {
            self.deviation = -2.5;
        }

        deviationOffsetY = self.radius * self.deviation * kLocalizerDeviationRatio;
    }
    else
    {
        if ( self.deviation > 10.0 )
        {
            self.deviation = 10.0;
        }
        else if ( self.deviation < -10.0 )
        {
            self.deviation = -10.0;
        }

        deviationOffsetY = self.radius * self.deviation * kLateralDeviationRatio;
    }

    if ( FALSE == drawILSMode )
    {
        // top/forward arrow-head segment
        CGContextMoveToPoint(ctx, self.radius * 0.5, deviationOffsetY);
        CGContextAddLineToPoint(ctx, self.radius * 0.417, (adf2Width * 0.5) + deviationOffsetY);
        
        // bottom/forward arrow-head segment
        CGContextMoveToPoint(ctx, self.radius * 0.5, deviationOffsetY);
        CGContextAddLineToPoint(ctx, self.radius * 0.417, (-(adf2Width * 0.5) + deviationOffsetY));
    }

    CGContextMoveToPoint(ctx, self.radius * 0.5, deviationOffsetY);
    CGContextAddLineToPoint(ctx, -(self.radius * 0.5), deviationOffsetY);

    CGContextDrawPath(ctx, kCGPathStroke);
    
    //
    // Draw VOR/ILS course deviation scale
    //
    CGContextBeginPath(ctx);

    CGContextSetStrokeColorWithColor(ctx, [CGColorHolder white]);

    CGContextMoveToPoint(ctx, self.radius * 0.025, self.radius * 0.5);
    CGContextAddArc(ctx, 0.0, self.radius * 0.5, self.radius * 0.025, 0.0, DegreesToRadians(360.0), 0);
    
    CGContextMoveToPoint(ctx, self.radius * 0.025, self.radius * 0.25);
    CGContextAddArc(ctx, 0.0, self.radius * 0.25, self.radius * 0.025, 0.0, DegreesToRadians(360.0), 0);
    
    CGContextMoveToPoint(ctx, self.radius * 0.025, self.radius * -0.5);
    CGContextAddArc(ctx, 0.0, self.radius * -0.5, self.radius * 0.025, 0.0, DegreesToRadians(360.0), 0);
    
    CGContextMoveToPoint(ctx, self.radius * 0.025, self.radius * -0.25);
    CGContextAddArc(ctx, 0.0, self.radius * -0.25, self.radius * 0.025, 0.0, DegreesToRadians(360.0), 0);
    
    CGContextDrawPath(ctx, kCGPathStroke);
    
	CGContextRestoreGState(ctx);
}

@end
