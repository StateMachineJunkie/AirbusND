/*
 *  NDUtilities.cpp
 *  AirbusND
 *
 *  Created by Michael A. Crawford on 11/15/08.
 *  Copyright 2008 Crawford Design Engineering, Inc. All rights reserved.
 *
 */

#include <assert.h>
#include <CoreGraphics/CGDirectDisplay.h>
#include "NDUtilities.h"

float
CalculatePixelsPerMillimeterForMainDisplay()
{
    //
    // This method will calculate an average pixels per millimeter taken from
    // the both the width and the height dimensions.
    //
    CGDirectDisplayID displayId = CGMainDisplayID();
    CGSize displaySizeInMillimeters = CGDisplayScreenSize(displayId);
    CGFloat pixelsHigh = CGDisplayPixelsHigh(displayId);
    CGFloat pixelsWide = CGDisplayPixelsWide(displayId);
    float pixelsPerMillimeter = pixelsHigh / displaySizeInMillimeters.height;
    pixelsPerMillimeter += pixelsWide / displaySizeInMillimeters.width;
    return ( pixelsPerMillimeter / 2 );
}

CGFloat
DegreesToDuration(CGFloat degreesTotal, CGFloat degreesPerSecond)
{
    if ( degreesTotal && degreesPerSecond )
    {
        return ( degreesTotal / degreesPerSecond );
    }
    return 0.0;
}

CGFloat
DegreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
}

//
// Any heading that is greater than 180 degrees must be converted in order for
// the rotation to occur in the proper direction so as to be most efficient.
// While heading values should always be positive, rotation values range from
// negative one hundred and seventy nine (-179) to positive one hundred and
// eighty (180).
//
CGFloat
HeadingToRotation(float heading)
{
    assert((heading >= 0.0) || (!"Heading values should always be positive"));
    
    if ( heading != 0.0 && heading > 180 )
    {
        heading = -(360.0 - heading);
    }
    
    return CGFloat(heading);
}

CGFloat
HeadingToInverseRotation(float heading)
{
    assert((heading >= 0.0) || (!"Heading values should always be positive"));
    
    if ( heading != 0.0 )
    {
        if ( heading <= 180 )
        {
            heading = -heading;
        }
        else
        {
            heading = (360 - heading);
        }
    }
    
    return CGFloat(heading);    
}

CGFloat
MillimetersToPixels(float mm)
{
    static float pixelsPerMillimeter = CalculatePixelsPerMillimeterForMainDisplay();
    return ( mm * pixelsPerMillimeter );
}

CGPoint
PointOnCircumference(CGFloat angle, CGFloat radius)
{
    return CGPointMake(radius * cos(DegreesToRadians(angle)),
                       radius * sin(DegreesToRadians(angle)));
}

CGFloat
RadiansToDegrees(CGFloat radians)
{
    return radians / M_PI / 180;
}

CGFloat
RotationToHeading(CGFloat radians)
{
    assert((radians >= 0.0) || (!"Rotation values should always be positive"));
    
    if ( radians != 0.0 )
    {
        radians = 360.0 - radians;
    }
    
    return radians;
}

CGFloat
WidthToHeight(CGFloat width)
{
    return ( width * kHeightToWidthRatio );
}
