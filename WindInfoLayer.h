//
//  SpeedInfoLayer.h
//
//  AirbusND wind-information layer.  Displays wind information in the Airbus
//  Navigation Display's upper left hand corner.  The positioning of this layer
//  is handled by the parent, the automatic display of the layer wind information
//  properties is handled by this class, whenever the properties are changed.
//
//  Created by Michael A. Crawford on 1/5/09.
//  Copyright 2009 Crawford Design Engineering, Inc. All rights reserved.
//

#import "NDInfoLayer.h"


@interface WindAndSpeedInfoLayer : NDInfoLayer
{
    NSInteger groundSpeed;
    NSInteger trueAirSpeed;
    
    static NSString* infoString;
}

- (void)setGroundSpeed:(NSInteger)groundSpeed;
- (void)setTrueAirSpeed:(NSInteger)trueAirSpeed;

@end
