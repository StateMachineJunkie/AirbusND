//
//  IPConfigPanelController.h
//  AirbusND
//
//  Created by Michael A. Crawford on 2/18/09.
//  Copyright 2009 Crawford Design Engineering, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AppController;

@interface IPConfigPanelController : NSWindowController
{
    IBOutlet NSButton* cancelButton;
    IBOutlet NSButton* okButton;
}

@property(nonatomic) IBOutlet NSTextField* ipOctet1;
@property(nonatomic) IBOutlet NSTextField* ipOctet2;
@property(nonatomic) IBOutlet NSTextField* ipOctet3;
@property(nonatomic) IBOutlet NSTextField* ipOctet4;
@property(nonatomic) IBOutlet NSTextField* udpPort;

- (IBAction)cancel:(id)sender;
- (IBAction)ok:(id)sender;

@end
