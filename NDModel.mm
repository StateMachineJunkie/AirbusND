//
//  NDModel.m
//  AirbusND
//
//  Created by Michael A. Crawford on 10/25/08.
//  Copyright 2008 Crawford Design Engineering, Inc. All rights reserved.
//

#import "NDModel.h"

@implementation NDModel

#pragma mark - Properties

@synthesize adf1Enabled;
@synthesize adf1Heading;
@synthesize adf2Enabled;
@synthesize adf2Heading;
@synthesize autopilotHeading;
@synthesize autopilotHeadingModeEnabled;
@synthesize compassHeading;
@synthesize glideSlopeDeviation;
@synthesize glideSlopeEnabled;
@synthesize groundSpeed;
@synthesize mode;
@synthesize navCourse;
@synthesize navCourseDeviation;
@synthesize navMode;
@synthesize range;
@synthesize track;
@synthesize trueAirSpeed;
@synthesize vor1Enabled;
@synthesize vor1Heading;
@synthesize vor2Enabled;
@synthesize vor2Heading;
@synthesize windDirection;
@synthesize windSpeed;

#pragma mark - Initialization Methods

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        adf1Enabled                 = YES;
        adf1Heading                 = 0.0;
        adf2Enabled                 = YES;
        adf2Heading                 = 0.0;
        autopilotHeading            = 0.0;
        autopilotHeadingModeEnabled = YES;
        compassHeading              = 0.0;
        glideSlopeDeviation         = 0.0;
        glideSlopeEnabled           = NO;
        groundSpeed                 = 0.0;
        navCourse                   = 0.0;
        navCourseDeviation          = 0.0;
        navMode                     = NDNavMode::Off;
        range                       = NDRange::NM_10;
        trueAirSpeed                = 0.0;
        vor1Enabled                 = NO;
        vor1Heading                 = 0.0;
        vor2Enabled                 = NO;
        vor2Heading                 = 0.0;
        windDirection               = 0.0;
        windSpeed                   = 0.0;
    }
    return self;
}

- (NSString*)description
{
    return @"NDModel for Airbus Navigation Display";
}

@end
