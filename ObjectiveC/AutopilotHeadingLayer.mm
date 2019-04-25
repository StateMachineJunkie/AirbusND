//
//  AutopilotHeadingLayer.m
//  AirbusND
//
//  Created by Michael A. Crawford on 11/15/08.
//  Copyright 2008 Crawford Design Engineering, Inc. All rights reserved.
//

#import "AutopilotHeadingLayer.h"
#import "CGColorHolder.h"
#import "NDUtilities.h"

@implementation AutopilotHeadingLayer

#pragma mark -
#pragma mark Initialization Methods

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        self.name = @"autopilotHeading";
    }
    
    return self;
}

#pragma mark - NSObject Overrides

- (NSString*)description
{
    return @"Airbus Navigation Display Autopilot-Heading layer";
}

#pragma mark - Drawing Methods

- (void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
    
	CGContextSaveGState(ctx);
    
    // set drawing properties
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetStrokeColorWithColor(ctx, [CGColorHolder blue]);
    
    //
	// Center and rotate the drawing context so that 0,0 is at the center and
    // zero degrees is at the top of the context.
    //
	CGContextTranslateCTM(ctx, CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextRotateCTM(ctx, DegreesToRadians(-90.0));
	
    //
    // Draw heading triangle outside of the compass-rose
    //
    [self drawTriangleAtPoint:CGPointMake(self.radius + 2.0, 0.0)
                      inContext:ctx
                      withAngle:0.0
                      andLength:self.radius * 0.115
             usingDrawingMode:kCGPathStroke];
    
	CGContextRestoreGState(ctx);
}

@end
