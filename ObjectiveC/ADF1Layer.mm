//
//  ADF1Layer.m
//  AirbusND
//
//  Created by Michael A. Crawford on 11/15/08.
//  Copyright 2008 Crawford Design Engineering, Inc. All rights reserved.
//

#import "ADF1Layer.h"
#import "CGColorHolder.h"
#import "NDUtilities.h"

@implementation ADF1Layer

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        self.name = @"ADF1";
    }
    
    return self;
}

#pragma mark - NSObject Overrides

- (NSString*)description
{
    return @"Airbus Navigation Display ADF-1 layer";
}

#pragma mark - Drawing

- (void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
    
	CGContextSaveGState(ctx);
    
    // set drawing properties
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetStrokeColorWithColor(ctx, [CGColorHolder green]);
    
    //
	// Center and rotate the drawing context so that 0,0 is at the center and
    // zero degrees is at the top of the context.
    //
    CGContextTranslateCTM(ctx, CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextRotateCTM(ctx, DegreesToRadians(-90.0));

    //
    // Draw ADF2 needle.  The arrow-heads of this needle have a width that is the
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
    
    // top/forward arrow-head segment
    CGContextMoveToPoint(ctx, self.radius * 0.916, 0.0);
    CGContextAddLineToPoint(ctx, self.radius * 0.833, adf2Width / 2.0);
    
    // bottom/forward arrow-head segment
    CGContextMoveToPoint(ctx, self.radius * 0.916, 0.0);
    CGContextAddLineToPoint(ctx, self.radius * 0.833, -(adf2Width / 2.0));
    
    
    // top/aft arrow-head segment
    CGContextMoveToPoint(ctx, -(self.radius * 0.833), 0.0);
    CGContextAddLineToPoint(ctx, -(self.radius * 0.916), adf2Width / 2.0);
    
    // bottom/aft arrow-head segment
    CGContextMoveToPoint(ctx, -(self.radius * 0.833), 0.0);
    CGContextAddLineToPoint(ctx, -(self.radius * 0.916), -(adf2Width / 2.0));
    
    CGContextDrawPath(ctx, kCGPathStroke);
    
	CGContextRestoreGState(ctx);
}

@end
