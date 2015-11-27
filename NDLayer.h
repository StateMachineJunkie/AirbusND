//
//  NDLayer.h
//  AirbusND
//
//  Created by Michael A. Crawford on 11/16/08.
//  Copyright 2008 Crawford Design Engineering, Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface NDLayer : CALayer

@property (nonatomic, readonly) CGFloat circumference;
@property (nonatomic, readonly) CGFloat diameter;
@property (nonatomic) CGFloat radius;
@property (nonatomic, readonly) CGFloat textSize;
@property (nonatomic) BOOL visible;

- (void)drawCarretAtPoint:(CGPoint)point
                inContext:(CGContextRef)ctx
               withLength:(CGFloat)length
         andUpOrientation:(BOOL)up;

- (void)drawRhombusAtPoint:(CGPoint)point
                 inContext:(CGContextRef)ctx
                 withAngle:(CGFloat)angle
                 andLength:(CGFloat)length
          usingDrawingMode:(CGPathDrawingMode)mode;

- (void)drawTriangleAtPoint:(CGPoint)point
                  inContext:(CGContextRef)ctx
                  withAngle:(CGFloat)angle
                  andLength:(CGFloat)length
           usingDrawingMode:(CGPathDrawingMode)mode;

@end
