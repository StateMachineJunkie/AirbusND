//
//  NavRadio.mm
//  AirbusND
//
//  The NavRadio class represents a model element that can be tuned either to an
//  ILS, NDB, or VOR.  NavRadios have DME, which, when tuned to the appropriate
//  nav-aid, will function.
//
//  Created by Michael A. Crawford on 12/5/08.
//  Copyright 2008 Crawford Design Engineering, Inc.. All rights reserved.
//

#import "NavRadio.h"

@implementation NavRadio

#pragma mark - NSObject

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        _mode = NavRadioMode::Off;
    }
    
    return self;
}

@end
