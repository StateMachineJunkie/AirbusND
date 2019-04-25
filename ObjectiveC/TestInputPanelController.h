//
//  TestInputPanelController.h
//  AirbusND
//
//  Created by Michael A. Crawford on 11/8/08.
//  Copyright 2008 Philips Medical Systems. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NDModel;

@interface TestInputPanelController : NSWindowController
{
    IBOutlet NSTextField*   adf1HeadingTextField;
    IBOutlet NSTextField*   adf2HeadingTextField;
    IBOutlet NSTextField*   autopilotHeadingTextField;
    IBOutlet NSTextField*   compassHeadingTextField;
    IBOutlet NSTextField*   glideSlopeDeviationTextField;
    IBOutlet NSTextField*   navCourseTextField;
    IBOutlet NSTextField*   navCourseDeviationTextField;
    IBOutlet NSTextField*   rangeTextField;
    IBOutlet NSTextField*   vor1HeadingTextField;
    IBOutlet NSTextField*   vor2HeadingTextField;
    
    IBOutlet NSStepper*     adf1HeadingStepper;
    IBOutlet NSStepper*     adf2HeadingStepper;
    IBOutlet NSStepper*     autopilotHeadingStepper;
    IBOutlet NSStepper*     compassHeadingStepper;
    IBOutlet NSStepper*     glideSlopeDeviationStepper;
    IBOutlet NSStepper*     navCourseStepper;
    IBOutlet NSStepper*     navCourseDeviationStepper;
    IBOutlet NSStepper*     vor1HeadingStepper;
    IBOutlet NSStepper*     vor2HeadingStepper;
    
    IBOutlet NSButton*      adf1Button;
    IBOutlet NSButton*      adf2Button;
    IBOutlet NSButton*      autopilotHeadingModeButton;
    IBOutlet NSButton*      glideSlopeButton;
    IBOutlet NSButton*      vor1Button;
    IBOutlet NSButton*      vor2Button;
    
    IBOutlet NSPopUpButton* navModePopUpButton;
    
    IBOutlet NSSlider*      rangeSlider;
    
    IBOutlet NDModel*       navigationDisplayModel;
}

- (id)initWithModel:(NDModel*)model;
- (IBAction)disableNavLayer:(id)sender;
- (IBAction)enableNavLayerForVORMode:(id)sender;
- (IBAction)enableNavLayerForILSMode:(id)sender;
- (IBAction)setRange:(id)sender;

@end
