//
//  NDViewController.h
//  AirbusND
//
//  Created by Michael A. Crawford on 7/18/09.
//  Copyright 2008-2009 Crawford Design Engineering, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NDModel;
@class NDView;
@class TestInputPanelController;

@interface NDViewController : NSViewController
{
    NDModel* model;
}

@property (nonatomic, readonly) NDModel* model;
@property (nonatomic, readonly) NDView* ndView;

- (id)initWithNibName:(NSString*)nibNameOrNil
			   bundle:(NSBundle*)bundleNameOrNil
				model:(NDModel*)model;

- (IBAction)startTestAnimation:(id)sender;
- (IBAction)stopTestAnimation:(id)sender;

@end
