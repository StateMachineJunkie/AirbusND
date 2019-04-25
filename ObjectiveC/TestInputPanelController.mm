//
//  TestInputPanelController.m
//  AirbusND
//
//  Created by Michael A. Crawford on 11/8/08.
//  Copyright 2008 Crawford Design Engineering, Inc. All rights reserved.
//

#import "TestInputPanelController.h"
#import "NDModel.h"

@implementation TestInputPanelController


#pragma mark - Initialization

- (id)initWithModel:(NDModel*)model
{
    self = [super initWithWindowNibName:@"TestInputPanel"];
    
    if ( self )
    {
        navigationDisplayModel = model;
    }
    
    return self;
}

- (void)awakeFromNib
{
    // verify that slider is properly configured
    NSAssert(6 == [rangeSlider maxValue], @"rangeSlider improperly calibrated");
    NSAssert(0 == [rangeSlider minValue], @"rangeSlider improperly calibrated");
}

#pragma mark - Target Actions

- (IBAction)disableNavLayer:(id)sender
{
    MCLog(@"disableNavLayer");
    navigationDisplayModel.navMode = NDNavMode::Off;
}

- (IBAction)enableNavLayerForILSMode:(id)sender
{
    MCLog(@"enableNavLayerForILSMode");
    navigationDisplayModel.navMode = NDNavMode::ILS;
}

- (IBAction)enableNavLayerForVORMode:(id)sender
{
    MCLog(@"enableNavLayerForVORMode");
    navigationDisplayModel.navMode = NDNavMode::VOR;
}

- (IBAction)setRange:(id)sender
{
    static NDRangeEnum rangeTable[6] = {
        NDRange::NM_10,
        NDRange::NM_20,
        NDRange::NM_40,
        NDRange::NM_80,
        NDRange::NM_160,
        NDRange::NM_320
    };
    
    navigationDisplayModel.range = rangeTable[[sender intValue]];
}

@end

#pragma mark - Scrollwheel behavior

//
// Add scroll-wheel support to NSSlider and NSStepper so that we can use our
// mouse-scrool-wheel to change test-input-panel input values.
//
@implementation NSSlider (Scrollwheel)

- (void)scrollWheel:(NSEvent*)event
{
    [self setFloatValue:([event deltaY] > 0.0 ? [self floatValue] + 1 : [self floatValue] - 1)];
	[self sendAction:[self action] to:[self target]];
}

@end

@implementation NSStepper (Scrollwheel)

- (void)scrollWheel:(NSEvent*)event
{
    [self setFloatValue:([event deltaY] > 0.0 ? [self floatValue] + [self increment] : [self floatValue] - [self increment])];
	[self sendAction:[self action] to:[self target]];
}

@end

