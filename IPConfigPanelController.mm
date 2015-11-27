//
//  IPConfigPanelController.mm
//  AirbusND
//
//  Created by Michael A. Crawford on 2/18/09.
//  Copyright 2009 Crawford Design Engineering, Inc. All rights reserved.
//

#import "IPConfigPanelController.h"

extern "C" NSString* const kXPlaneIPAddressKey;
extern "C" NSString* const kXPlaneUDPPortKey;


@implementation IPConfigPanelController

#pragma mark - Initialization

- (id)init
{
    return [super initWithWindowNibName:@"IPConfigPanel"];
}

#pragma mark - NSObject Overrides

- (NSString*)description
{
    return @"IPConfigPanel controller for Airbus Navigation Display";
}

#pragma mark - Target/Action Methods

- (IBAction)cancel:(id)sender
{
    [self.window close];
}

- (IBAction)ok:(id)sender
{
    uint32_t address = [_ipOctet1 intValue];
    (address <<= 8) += [_ipOctet2 intValue];
    (address <<= 8) += [_ipOctet3 intValue];
    (address <<= 8) += [_ipOctet4 intValue];
    
    uint32_t port = [_udpPort intValue];

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithUnsignedLong:address]
                forKey:kXPlaneIPAddressKey];
    [defaults setValue:[NSNumber numberWithUnsignedShort:port]
                forKey:kXPlaneUDPPortKey];
    [self.window close];
}

#pragma mark - Delegate Methods

- (void)awakeFromNib
{
    // load panel values from NSDefaults
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    uint16_t port = [[defaults valueForKey:kXPlaneUDPPortKey] unsignedShortValue];
    [_udpPort setIntValue:port];

    uint32_t address = [[defaults valueForKey:kXPlaneIPAddressKey] unsignedIntValue];
    [_ipOctet4 setIntValue:(0xff & address)];
    [_ipOctet3 setIntValue:(0xff & (address >> 8))];
    [_ipOctet2 setIntValue:(0xff & (address >> 16))];
    [_ipOctet1 setIntValue:(0xff & (address >> 24))];
}

- (void)windowDidLoad
{
    NSLog(@"Nib file is loaded");
}

- (void)windowWillClose:(NSNotification*)note
{
    NSLog(@"IPConfigController window closing");
}

@end
