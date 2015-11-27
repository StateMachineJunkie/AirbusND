//
//  NDViewController.m
//  AirbusND
//
//  Created by Michael A. Crawford on 7/18/09.
//  Copyright 2009 Crawford Design Engineering, LLC. All rights reserved.
//

#import "NDViewController.h"
#import "NDModel.h"
#import "NDView.h"
#import "TestInputPanelController.h"

@implementation NDViewController

#pragma mark -
#pragma mark Initialization

- (id)initWithNibName:(NSString*)nibNameOrNil
			   bundle:(NSBundle*)nibBundleOrNil
				model:(NDModel*)newModel
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if ( self )
    {
        model = newModel;
    }
    
    return self;
}

- (NSString*)description
{
    return @"Airbus Navigation Display Controller";
}

- (void)awakeFromNib
{
    NSLog(@"%@: awakeFromNib", self);
}

#pragma mark -
#pragma mark Properties

@synthesize model;

- (NDView*)ndView
{
	// This is a handy getter to keep me from having to cast the view every time
	// I fetch it.
	return (NDView*)self.view;
}

#pragma mark -
#pragma mark Target/Action Methods

- (IBAction)startTestAnimation:(id)sender
{
	NSLog(@"Test animation started");
	[self.ndView startAnimation];
    [sender setTitle:@"Stop Test Animation"];
    [sender setAction:@selector(stopTestAnimation:)];
}

- (IBAction)stopTestAnimation:(id)sender
{
    NSLog(@"Test animation stopped");
    [self.ndView stopAnimation];
    [sender setTitle:@"Start Test Animation"];
    [sender setAction:@selector(startTestAnimation:)];
}

@end
