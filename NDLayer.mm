//
//  NDLayer.mm
//  AirbusND
//
//  Created by Michael A. Crawford on 11/16/08.
//  Copyright 2008 Crawford Design Engineering, Inc. All rights reserved.
//

#import "NDLayer.h"
#import "NDUtilities.h"

@implementation NDLayer

#pragma mark - NSObject Overrides

- (NSString*)description
{
    return @"Airbus Navigation Display layer";
}

#pragma mark - Public Methods

- (CGFloat)circumference
{
    return ( M_PI * 2.0 * _radius );
}

- (CGFloat)diameter
{
    return ( 2.0 * _radius );
}

- (void)setVisible:(BOOL)isVisible
{
    self.hidden = !isVisible;
}
     
- (CGFloat)textSize
{
    return ( _radius * 0.10 );
}

- (BOOL)visible
{
    return !self.hidden;
}

#pragma mark - Drawing Methods

- (void)drawInContext:(CGContextRef)ctx
{
    _radius = (MIN(self.bounds.size.width * 0.9, self.bounds.size.height * 0.9) * 0.70) / 2.0;
}

- (void)drawCarretAtPoint:(CGPoint)point
                inContext:(CGContextRef)ctx
               withLength:(CGFloat)length
         andUpOrientation:(BOOL)up
{
    //
    // Caller should set any drawing properties including line-width, fill-color,
    // stroke-color.  This method makes no permanent changes to the given context.
    //
	CGContextSaveGState(ctx);
    
	// translate and rotate the drawing context for this drawing procedure
	CGContextTranslateCTM(ctx, point.x, point.y);
	
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0.0, 0.0);
    
    CGPoint vertexPoint;
    
    if ( up )
    {
        vertexPoint = PointOnCircumference(30.0, length);
    }
    else
    {
        vertexPoint = PointOnCircumference(-30.0, length);
    }

    CGContextAddLineToPoint(ctx, vertexPoint.x, vertexPoint.y);
    CGContextAddLineToPoint(ctx, vertexPoint.x * 2.0, 0.0);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    CGContextRestoreGState(ctx);
}

- (void)drawRhombusAtPoint:(CGPoint)point
                  inContext:(CGContextRef)ctx
                  withAngle:(CGFloat)angle
                  andLength:(CGFloat)length
           usingDrawingMode:(CGPathDrawingMode)mode
{
    //
    // Caller should set any drawing properties including line-width, fill-color,
    // stroke-color.  This method makes no permanent changes to the given context.
    //
	CGContextSaveGState(ctx);
    
	// translate and rotate the drawing context for this drawing procedure
	CGContextTranslateCTM(ctx, point.x, point.y);
    CGContextRotateCTM(ctx, DegreesToRadians(angle));
	
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0.0, 0.0);
    CGPoint vertexPoint = PointOnCircumference(30, length);
    CGContextAddLineToPoint(ctx, vertexPoint.x, vertexPoint.y);
    CGContextAddLineToPoint(ctx, vertexPoint.x * 2.0, 0.0);
    CGContextAddLineToPoint(ctx, vertexPoint.x, -vertexPoint.y);
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, mode);
    
    CGContextRestoreGState(ctx);
}

- (void)drawTriangleAtPoint:(CGPoint)point
                  inContext:(CGContextRef)ctx
                  withAngle:(CGFloat)angle
                  andLength:(CGFloat)length
           usingDrawingMode:(CGPathDrawingMode)mode
{
    //
    // Caller should set any drawing properties including line-width, fill-color,
    // stroke-color.  This method makes no permanent changes to the given context.
    // all triangles drawn by this routine are assumed to be equilateral.
    //
	CGContextSaveGState(ctx);
    
	// translate and rotate the drawing context for this drawing procedure
	CGContextTranslateCTM(ctx, point.x, point.y);
    CGContextRotateCTM(ctx, DegreesToRadians(angle));
	
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0.0, 0.0);
    CGPoint vertexPoint = PointOnCircumference(30, length);
    CGContextAddLineToPoint(ctx, vertexPoint.x, vertexPoint.y);
    CGContextAddLineToPoint(ctx, vertexPoint.x, -vertexPoint.y);
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, mode);
    
    CGContextRestoreGState(ctx);
}

@end
