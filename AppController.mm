//
//  AppController.m
//  AirbusND
//
//  Created by Michael A. Crawford on 10/27/08.
//  Copyright 2008 Philips Medical Systems. All rights reserved.
//

#import "AppController.h"
#import "IPConfigPanelController.h"
#import "NDModel.h"
#import "NDViewController.h"
#import "PFDViewController.h"
#import "TestInputPanelController.h"
#import "UDPServer.h"
#include "XPlaneData.h"

NSString* const kXPlaneIPAddressKey = @"XPlaneIPAddress";
NSString* const kXPlaneUDPPortKey   = @"XPlaneUDPPort";

@interface AppController ()
@property (nonatomic, retain) PFDViewController* pfdViewController;
@property (nonatomic, retain) NDViewController* ndViewController;
@end

@implementation AppController

#pragma mark - Initialization

+ (void)initialize
{
    if ( [AppController class] == self )
    {
        // set default IP address and UDP port number for X-Plane data server
        NSMutableDictionary* defaultValues = [NSMutableDictionary dictionary];
        [defaultValues setValue:[NSNumber numberWithUnsignedLong:INADDR_LOOPBACK]
                         forKey:kXPlaneIPAddressKey];
        [defaultValues setValue:[NSNumber numberWithUnsignedShort:kXPlaneDefaultUDPPort]
                         forKey:kXPlaneUDPPortKey];
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
    }
}
                          
- (NSString*)description
{
    return @"Airbus Navigation Display Application Controller";
}

- (void)awakeFromNib
{
    NSLog(@"%@: awakeFromNib", self);
	
	// create ND window
	self.ndViewController = [[NDViewController alloc] initWithNibName:@"NDView"
														  bundle:nil
														   model:navigationDisplayModel];
	ndWindow.contentView = self.ndViewController.view;
#if 0	
	// create PFD window
	pfdViewController = [[PFDViewController alloc] initWithNibName:@"PFDView"
															bundle:nil
															 model:navigationDisplayModel];
	pfdWindow.contentView = pfdViewController.view;
#endif
}

#pragma mark - Target/Action Methods

- (IBAction)hideTestInputPanel:(id)sender
{
    NSLog(@"Hiding %@", testInputPanelController);
    [testInputPanelController close];
    [sender setTitle:@"Show Test Input Panel"];
    [sender setAction:@selector(showTestInputPanel:)];
}

- (IBAction)showIPConfigPanel:(id)sender
{
    if ( nil == ipConfigPanelController )
    {
        ipConfigPanelController = [IPConfigPanelController new];
    }
    
    NSLog(@"Showing %@", ipConfigPanelController);
    [ipConfigPanelController showWindow:self];
}

- (IBAction)showTestInputPanel:(id)sender
{
    if ( nil == testInputPanelController )
    {
        testInputPanelController =
            [[TestInputPanelController alloc] initWithModel:navigationDisplayModel];
    }
    
    NSLog(@"Showing %@", testInputPanelController);
    [testInputPanelController showWindow:self];
    [sender setTitle:@"Hide Test Input Panel"];
    [sender setAction:@selector(hideTestInputPanel:)];
}

- (IBAction)start:(id)sender
{
    NSLog(@"Start");
    [self startDataUpdates];
    [sender setTitle:@"Stop"];
    [sender setAction:@selector(stop:)];
}

- (IBAction)startTestAnimation:(id)sender
{
	NSLog(@"Start Test Animation");
	[self.pfdViewController startTestAnimation:sender];
	[self.ndViewController startTestAnimation:sender];
}

- (IBAction)stop:(id)sender
{
    NSLog(@"Stop");
    [self stopDataUpdates];
    [sender setTitle:@"Start"];
    [sender setAction:@selector(start:)];
}

#pragma mark -
#pragma mark App Methods

- (void)startDataUpdates
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    self.udpServer.port = kXPlaneDefaultUDPPort;    // take the next available port
    NSError* nsError = nil;
    BOOL udpServerStarted = [self.udpServer start:&nsError];
    
    if ( udpServerStarted )
    {
        SocketAddress socketAddress;
        socketAddress.sin_len           = sizeof(struct sockaddr_in);
        socketAddress.sin_family        = AF_INET;
        socketAddress.sin_port          = htons([[defaults valueForKey:kXPlaneUDPPortKey] unsignedShortValue]);
        socketAddress.sin_addr.s_addr   = htonl([[defaults valueForKey:kXPlaneIPAddressKey] unsignedIntValue]);

        XPLANE_DSEL_MESG msg = MakeXPlaneDataSelectMessage(ntohl(socketAddress.sin_addr.s_addr),kFrameRate);

        NSData* data = [NSData dataWithBytes:&msg length:sizeof(msg)];
        [self.udpServer sendData:data ToAddress:&socketAddress];
    }
}

- (void)stopDataUpdates
{
    // TBD
}

#pragma mark - Delegate Methods

- (void)UDPServer:(UDPServer*)server
   didReceiveData:(NSData*)data
      fromAddress:(SocketAddressRef)socketAddress
{
    if ( sizeof(XPLANE_DATA_MESG) == [data length] )
    {
        XPLANE_DATA_MESG const* pInputData =
            reinterpret_cast<XPLANE_DATA_MESG const*> ([data bytes]);
        
        if ( kFrameRate == pInputData->data.index )
        {
            // TBD
        }
        else
        {
            NSLog(@"Unrecognized input data: %u", pInputData->data.index);
        }
    }
}

@end
