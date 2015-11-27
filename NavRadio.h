//
//  NavRadio.h
//  AirbusND
//
//  The NavRadio class represents a model element that can be tuned either to an
//  ILS, NDB, or VOR.  NavRadios have DME, which, when tuned to the appropriate
//  nav-aid, will function.
//
//  Created by Michael A. Crawford on 12/5/08.
//  Copyright 2008 Crawford Design Engineering, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MCNavAid.h"

namespace NavRadioMode  // Navigation radio mode values
{
    enum NavRadioMode
    {
        Off,
        ADF,
        ILS,
        VOR
    };
}
typedef NavRadioMode::NavRadioMode NavRadioModeEnum;

@interface NavRadio : NSObject

@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) CGFloat frequency;
@property (nonatomic, assign) NavRadioModeEnum mode;
@property (nonatomic, assign) MCNavAid navAid;

@end
