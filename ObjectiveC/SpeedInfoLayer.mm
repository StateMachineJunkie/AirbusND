//
//  SpeedInfoLayer.mm
//
//  AirbusND speed-information layer.  Displays wind information in the Airbus
//  Navigation Display's upper left hand corner.  The positioning of this layer
//  is handled by the parent, the automatic display of the layer speed information
//  properties is handled by this class, whenever the properties are changed.
//
//  Created by Michael A. Crawford on 1/5/09.
//  Copyright 2009 Crawford Design Engineering, Inc. All rights reserved.
//

#import "SpeedInfoLayer.h"


@implementation SpeedInfoLayer

#pragma mark -
#pragma mark Initialization Methods

- (NSString*)description
{
    return @"Airbus Navigation Display Speed Information Layer";
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        speedInfo.groundSpeed = speedInfo.trueAirSpeed = 0;
        
        NSString* s = [[NSString alloc] initWithFormat:@"GS %.3li TAS %.3li", (long)speedInfo.groundSpeed, (long)speedInfo.trueAirSpeed];
        speedInfoString = [[NSMutableAttributedString alloc] initWithString:s];
        
        // set attributes for labels
        [speedInfoString addAttribute:NSFontAttributeName
                                value:self.labelFont
                                range:NSMakeRange(0, 2)];
        
        [speedInfoString addAttribute:NSForegroundColorAttributeName
                                value:[NSColor whiteColor]
                                range:NSMakeRange(0, 2)];
        
        [speedInfoString addAttribute:NSFontAttributeName
                                value:self.labelFont
                                range:NSMakeRange(7, 3)];
        
        [speedInfoString addAttribute:NSForegroundColorAttributeName
                                value:[NSColor whiteColor]
                                range:NSMakeRange(7, 3)];
        
        // set attributes for values
        [speedInfoString addAttribute:NSFontAttributeName
                                value:self.valueFont
                                range:NSMakeRange(3, 3)];
        
        [speedInfoString addAttribute:NSForegroundColorAttributeName
                                value:[NSColor greenColor]
                                range:NSMakeRange(3, 3)];
        
        [speedInfoString addAttribute:NSFontAttributeName
                                value:self.valueFont
                                range:NSMakeRange(11, 3)];
        
        [speedInfoString addAttribute:NSForegroundColorAttributeName
                                value:[NSColor greenColor]
                                range:NSMakeRange(11, 3)];
        
        self.string = speedInfoString;
    }

    return self;
}

#pragma mark -
#pragma mark Properies

- (void)setSpeedInfo:(SpeedInfoRef)info
{
    speedInfo = *info;
}

- (SpeedInfoRef)speedInfo
{
    return &speedInfo;
}

#pragma mark -
#pragma mark Drawing Methods

- (void)applyInfoStringAttributes
{
    //
    // This method is called whenever the associated layer needs to be resized
    // and re-drawn.  The string length should be constant due to the format of
    // the speed information, which is "GS nnn TAS nnn".  Thus the only attribute
    // that need ever changes is the size of the font.
    //
    // set attributes for labels
    [speedInfoString removeAttribute:NSFontAttributeName range:NSMakeRange(0, 2)];
    [speedInfoString addAttribute:NSFontAttributeName
                            value:self.labelFont
                            range:NSMakeRange(0, 2)];
    
    [speedInfoString removeAttribute:NSFontAttributeName range:NSMakeRange(7, 3)];
    [speedInfoString addAttribute:NSFontAttributeName
                            value:self.labelFont
                            range:NSMakeRange(7, 3)];
    
    // set attributes for values
    [speedInfoString removeAttribute:NSFontAttributeName range:NSMakeRange(3, 3)];
    [speedInfoString addAttribute:NSFontAttributeName
                            value:self.valueFont
                            range:NSMakeRange(3, 3)];
    
    [speedInfoString removeAttribute:NSFontAttributeName range:NSMakeRange(11, 3)];
    [speedInfoString addAttribute:NSFontAttributeName
                            value:self.valueFont
                            range:NSMakeRange(11, 3)];
}

- (void)drawInfoString
{
    NSString* s = [[NSString alloc] initWithFormat:@"GS %.3li TAS %.03li", (long)speedInfo.groundSpeed, (long)speedInfo.trueAirSpeed];
    [speedInfoString replaceCharactersInRange:NSMakeRange(0, [s length]) withString:s];
    
    [self applyInfoStringAttributes];

    // cache new text-size
    self.string = speedInfoString;
}

@end
