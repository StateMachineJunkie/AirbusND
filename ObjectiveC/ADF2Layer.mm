//
//  ADF2Layer.m
//  AirbusND
//
//  Created by Michael A. Crawford on 11/15/08.
//  Copyright 2008 Crawford Design Engineering, Inc. All rights reserved.
//

#import "ADF2Layer.h"
#import "CGColorHolder.h"
#import "NDUtilities.h"

@implementation ADF2Layer

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        self.name = @"ADF2";
    }
    
    return self;
}

#pragma mark - NSObject Overrides

- (NSString*)description
{
    return @"Airbus Navigation Display ADF-2 layer";
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
    // Draw ADF2 needle.  This needle has a with approx the same as 10 degrees of
    // separation on the compase rose.  Therefore we divide the circumference by
    // 36 in order to scale it appropriately if the gauge is re-sized.
    //
    CGFloat adf2Width = self.circumference / 36.0;
    CGContextBeginPath(ctx);
    
    // top/forward segment
    CGContextMoveToPoint(ctx, self.radius * 0.584, adf2Width / 2.0);
    CGContextAddLineToPoint(ctx, self.radius * 0.5, adf2Width / 2.0);
    
    // top/aft segment
    CGContextMoveToPoint(ctx, -(self.radius * 0.75), adf2Width / 2.0 );
    CGContextAddLineToPoint(ctx, -(self.radius * 0.5), adf2Width / 2.0);
    
    // botton/forward segment
    CGContextMoveToPoint(ctx, self.radius * 0.584, -(adf2Width / 2.0));
    CGContextAddLineToPoint(ctx, self.radius * 0.5, -(adf2Width / 2.0));
    
    // bottom/aft segment
    CGContextMoveToPoint(ctx, -(self.radius * 0.75), -(adf2Width / 2.0));
    CGContextAddLineToPoint(ctx, -(self.radius * 0.5), -(adf2Width / 2.0));
    
    // center/forward segment
    CGContextMoveToPoint(ctx, self.radius, 0.0);
    CGContextAddLineToPoint(ctx, self.radius * 0.667, 0.0);
    
    // center/aft segment
    CGContextMoveToPoint(ctx, -self.radius, 0.0);
    CGContextAddLineToPoint(ctx, -(self.radius * 0.667), 0.0);
    
    // connector center/forward to top/forward
    CGContextMoveToPoint(ctx, self.radius * 0.667, 0.0);
    CGContextAddLineToPoint(ctx, self.radius * 0.584, adf2Width / 2.0);
    
    // connector center/forward to bottom/forward
    CGContextMoveToPoint(ctx, self.radius * 0.667, 0.0);
    CGContextAddLineToPoint(ctx, self.radius * 0.584, -(adf2Width / 2.0));
    
    
    // connector center/aft to top/aft
    CGContextMoveToPoint(ctx, -(self.radius * 0.667), 0.0);
    CGContextAddLineToPoint(ctx, -(self.radius * 0.75), adf2Width / 2.0);
    
    // connector center/aft to bottom/aft
    CGContextMoveToPoint(ctx, -(self.radius * 0.667), 0.0);
    CGContextAddLineToPoint(ctx, -(self.radius * 0.75), -(adf2Width / 2.0));
    
    CGContextDrawPath(ctx, kCGPathStroke);
    
	CGContextRestoreGState(ctx);
}

@end
