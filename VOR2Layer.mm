//
//  VOR2Layer.m
//  AirbusND
//
//  Created by Michael A. Crawford on 11/23/08.
//  Copyright 2008 Crawford Design Engineering, Inc. All rights reserved.
//

#import "VOR2Layer.h"
#import "CGColorHolder.h"
#import "NDUtilities.h"

@implementation VOR2Layer

#pragma mark -
#pragma mark Initialization Methods

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        self.name = @"VOR2";
    }
    
    return self;
}

- (NSString*)description
{
    return @"Airbus Navigation Display VOR-2 layer";
}

#pragma mark -
#pragma mark Drawing Methods

- (void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
    
	CGContextSaveGState(ctx);
    
    // set drawing properties
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetStrokeColorWithColor(ctx, [CGColorHolder white]);
    
    //
	// Center and rotate the drawing context so that 0,0 is at the center and
    // zero degrees is at the top of the context.
    //
    CGContextTranslateCTM(ctx, CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextRotateCTM(ctx, DegreesToRadians(-90.0));

    //
    // Draw VOR2 needle.  The arrow-heads of this needle have a width that is the
    // same as the width of the ADF2 needle.
    //
    CGFloat adf2Width = self.circumference / 36.0;
    CGContextBeginPath(ctx);

    // center/forward segment
    CGContextMoveToPoint(ctx, self.radius, 0.0);
    CGContextAddLineToPoint(ctx, self.radius * 0.7915, 0.0);
    
    // top/forward segment
    CGContextMoveToPoint(ctx, self.radius * 0.7085, adf2Width / 4.0);
    CGContextAddLineToPoint(ctx, self.radius * 0.5, adf2Width / 4.0);
    
    // bottom/forward segment
    CGContextMoveToPoint(ctx, self.radius * 0.7085, -(adf2Width / 4.0));
    CGContextAddLineToPoint(ctx, self.radius * 0.5, -(adf2Width / 4.0));
    
    // top/forward arrow-head segment
    CGContextMoveToPoint(ctx, self.radius * 0.7915, 0.0);
    CGContextAddLineToPoint(ctx, self.radius * 0.7085, adf2Width / 2.0);
    CGContextAddLineToPoint(ctx, self.radius * 0.7085, adf2Width / 4.0);
    
    // bottom/forward arrow-head segment
    CGContextMoveToPoint(ctx, self.radius * 0.7915, 0.0);
    CGContextAddLineToPoint(ctx, self.radius * 0.7085, -(adf2Width / 2.0));
    CGContextAddLineToPoint(ctx, self.radius * 0.7085, -(adf2Width / 4.0));
    
    // top/aft segment
    CGContextMoveToPoint(ctx, -(self.radius * 0.5), adf2Width / 4.0);
    CGContextAddLineToPoint(ctx, -(self.radius * 0.7085), adf2Width / 4.0);
    
    // bottom/aft segment
    CGContextMoveToPoint(ctx, -(self.radius * 0.5), -(adf2Width / 4.0));
    CGContextAddLineToPoint(ctx, -(self.radius * 0.7085), -(adf2Width / 4.0));

    // connect tails of previous two segments to form a closed aft segment
    CGContextAddLineToPoint(ctx, -(self.radius * 0.7085), adf2Width / 4.0);

    // center/aft segment
    CGContextMoveToPoint(ctx, -self.radius, 0.0);
    CGContextAddLineToPoint(ctx, -(self.radius * 0.7085), 0.0);
    
    CGContextDrawPath(ctx, kCGPathStroke);
    
	CGContextRestoreGState(ctx);
}

@end
