//
//  PFDViewController.m
//  AirbusND
//
//  Created by Michael A. Crawford on 7/18/09.
//  Copyright 2009 Crawford Design Engineering, LLC. All rights reserved.
//

#import "NDModel.h"
#import "PFDView.h"
#import "PFDViewController.h"

@implementation PFDViewController

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
    return @"Airbus Primay Flight Display Controller";
}

- (void)awakeFromNib
{
    NSLog(@"%@: awakeFromNib", self);
}

#pragma mark -
#pragma mark Properties

@synthesize model;

- (PFDView*)pfdView
{
	// This is a handy getter to keep me from having to cast the view every time
	// I fetch it.
	return (PFDView*)self.view;
}

#pragma mark -
#pragma mark Target/Action Methods

- (IBAction)startTestAnimation:(id)sender
{
	NSLog(@"Test animation started");
	[self.pfdView startAnimation];
    [sender setTitle:@"Stop Test Animation"];
    [sender setAction:@selector(stopTestAnimation:)];
}

- (IBAction)stopTestAnimation:(id)sender
{
    NSLog(@"Test animation stopped");
    [self.pfdView stopAnimation];
    [sender setTitle:@"Start Test Animation"];
    [sender setAction:@selector(startTestAnimation:)];
}

@end
