/*
 *  NDUtilities.h
 *  AirbusND
 *
 *  Created by Michael A. Crawford on 11/15/08.
 *  Copyright 2008 Crawford Design Engineering, Inc. All rights reserved.
 *
 */
#ifndef _ND_UTILITIES_H_
#define _ND_UTILITIES_H_

#include <QuartzCore/CABase.h>

#define kCornerRadius (radius * 0.50)
#define kHeightToWidthRatio 1.03125
#define kTransformRotationZ @"transform.rotation.z"
#define kMaxDisplays 4
#define kClockwise 1
#define kCounterClockwise 0

#ifdef __cplusplus
extern "C" {
#endif
    float CalculatePixelsPerMillimeterForMainDisplay(void);
    CGFloat DegreesToDuration(CGFloat degreesTotal, CGFloat degreesPerSecond);
    CGFloat DegreesToRadians(CGFloat degrees);
    CGFloat HeadingToRotation(float heading);
    CGFloat HeadingToInverseRotation(float heading);
    CGFloat MillimetersToPixels(float mm);
    CGPoint PointOnCircumference(CGFloat angle, CGFloat radius);
    CGFloat RadiansToDegrees(CGFloat radians);
    CGFloat RotationToHeading(CGFloat rotation);
    CGFloat WidthToHeight(CGFloat width);
#ifdef __cplusplus
}
#endif

#endif /* _ND_UTILITIES_H_ */
