//
//  AppController.h
//  AirbusND
//
//  Created by Michael A. Crawford on 10/27/08.
//  Copyright 2008 Crawford Design Engineering, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#if 0
#define kServiceType @"_airbus_telemetry._tcp"
#endif

#define kXPlaneDefaultUDPPort 49001

extern NSString* const kXPlaneIPAddressKey;
extern NSString* const kXPlaneUDPPortKey;

@class IPConfigPanelController;
@class NDModel;
@class TestInputPanelController;
@class UDPServer;

@interface AppController : NSController
{
	IBOutlet NSWindow* ndWindow;
	IBOutlet NSWindow* pfdWindow;
	
    IBOutlet NDModel* navigationDisplayModel;

    IBOutlet IPConfigPanelController*   ipConfigPanelController;
    IBOutlet TestInputPanelController*  testInputPanelController;
}

@property(retain, nonatomic) IBOutlet UDPServer* udpServer;

- (IBAction)hideTestInputPanel:(id)sender;
- (IBAction)showIPConfigPanel:(id)sender;
- (IBAction)showTestInputPanel:(id)sender;
- (IBAction)start:(id)sender;
- (IBAction)startTestAnimation:(id)sender;
- (void)startDataUpdates;
- (IBAction)stop:(id)sender;
- (void)stopDataUpdates;

@end
