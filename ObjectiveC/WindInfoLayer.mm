//
//  SpeedInfoLayer.mm
//
//  AirbusND wind-information layer.  Displays wind information in the Airbus
//  Navigation Display's upper left hand corner.  The positioning of this layer
//  is handled by the parent, the automatic display of the layer wind information
//  properties is handled by this class, whenever the properties are changed.
//
//  Created by Michael A. Crawford on 1/5/09.
//  Copyright 2009 Crawford Design Engineering, Inc. All rights reserved.
//

#import "WindInfoLayer.h"


@implementation WindAndSpeedInfoLayer

#pragma mark -
#pragma mark Initialization Methods

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        groundSpeed     = 0;
        trueAirSpeed    = 0;
        windDirection   = 0;
        windSpeed       = 0;
    }
    
    NSString* s = [[NSString alloc] initWithFormat:@"GS %.03i TAS %.03i", groundSpeed, trueAirSpeed];
    speedInfoString = [[NSMutableAttributedString alloc] initWithString:s];
    [s release];
    
    s = [[NSString alloc] initWithFormat:@"%.03i/%i", windDirection, windSpeed];
    windInfoString = [[NSMutableAttributedString alloc] initWithString:s];
    [s release];
    
    // set attributes for labels
    [speedInfoString addAttribute:NSFontAttributeName
                            value:labelFont
                            range:NSMakeRange(0, 2)];
    
    [speedInfoString addAttribute:NSForegroundColorAttributeName
                            value:[NSColor whiteColor]
                            range:NSMakeRange(0, 2)];
    
    [speedInfoString addAttribute:NSFontAttributeName
                            value:labelFont
                            range:NSMakeRange(7, 3)];
    
    [speedInfoString addAttribute:NSForegroundColorAttributeName
                            value:[NSColor whiteColor]
                            range:NSMakeRange(7, 3)];
    
    // set attributes for values
    [speedInfoString addAttribute:NSFontAttributeName
                            value:valueFont
                            range:NSMakeRange(3, 3)];
    
    [speedInfoString addAttribute:NSForegroundColorAttributeName
                            value:[NSColor greenColor]
                            range:NSMakeRange(3, 3)];
    
    [speedInfoString addAttribute:NSFontAttributeName
                            value:valueFont
                            range:NSMakeRange(11, 3)];
    
    [speedInfoString addAttribute:NSForegroundColorAttributeName
                            value:[NSColor greenColor]
                            range:NSMakeRange(11, 3)];
    
    [windInfoString addAttribute:NSFontAttributeName
                           value:valueFont
                           range:NSMakeRange(0, windInfoString.length)];
    
    [windInfoString addAttribute:NSForegroundColorAttributeName
                           value:[NSColor greenColor]
                           range:NSMakeRange(0, windInfoString.length)];
    
    // set attributes for waypoint info
    [waypointInfoString addAttribute:NSFontAttributeName
                               value:valueFont
                               range:NSMakeRange(0, 8)];
    
    [waypointInfoString addAttribute:NSForegroundColorAttributeName
                               value:[NSColor whiteColor]
                               range:NSMakeRange(0, 3)];
    
    [waypointInfoString addAttribute:NSForegroundColorAttributeName
                               value:[NSColor greenColor]
                               range:NSMakeRange(3, 5)];
    
    
    return self;
}

- (void)updateSpeedString
{
    // set attributes for labels
    [speedInfoString removeAttribute:NSFontAttributeName range:NSMakeRange(0, 2)];
    [speedInfoString addAttribute:NSFontAttributeName
                            value:labelFont
                            range:NSMakeRange(0, 2)];
    
    [speedInfoString removeAttribute:NSFontAttributeName range:NSMakeRange(7, 3)];
    [speedInfoString addAttribute:NSFontAttributeName
                            value:labelFont
                            range:NSMakeRange(7, 3)];
    
    // set attributes for values
    [speedInfoString removeAttribute:NSFontAttributeName range:NSMakeRange(3, 3)];
    [speedInfoString addAttribute:NSFontAttributeName
                            value:valueFont
                            range:NSMakeRange(3, 3)];
    
    [speedInfoString removeAttribute:NSFontAttributeName range:NSMakeRange(11, 3)];
    [speedInfoString addAttribute:NSFontAttributeName
                            value:valueFont
                            range:NSMakeRange(11, 3)];
    
    // cache new text-size
    self.string   = speedInfoString;
    windInfoLayer.string    = windInfoString;
    previousTextSize        = self.textSize;
}

- (void)updateWindInfoString
{
    ;
}

@end
