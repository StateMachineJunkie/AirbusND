//
//  NDModel.h
//  Airbus Navigation Display model.  This class embodies the state and behavior
//	of the ND model and its component parts.
//
//  Created by Michael A. Crawford on 10/25/08.
//  Copyright 2008 Philips Medical Systems. All rights reserved.
//

#import <Cocoa/Cocoa.h>

namespace NDMode // Navigation Display master-mode values
{
    enum NDMode
    {
        RoseILS,    // compass-rose ILS mode
        RoseVOR,    // compass-rose VOR mode
        RoseNAV,    // compass-rose NAV mode
        ArcNAV,     // arc NAV mode
        Plan        // plan mode
    };
}
typedef NDMode::NDMode NDModeEnum;

namespace NDNavMode // Navigation Display NAV-layer mode values
{
    enum NDNavMode
    {
        Off,
        ILS,
        VOR
    };
}
typedef NDNavMode::NDNavMode NDNavModeEnum;

namespace NDRange   // Navigation Display range values
{
    enum NDRange    // in nautical miles
    {
        NM_10   = 10,
        NM_20   = 20,
        NM_40   = 40,
        NM_80   = 80,
        NM_160  = 160,
        NM_320  = 320
    };
}
typedef NDRange::NDRange NDRangeEnum;

@interface NDModel : NSObject
{
	BOOL            adf1Enabled;                // ADF1 on/off state
	float           adf1Heading;                // ADF1 directional vector
	BOOL            adf2Enabled;                // ADF2 on/off state
	float           adf2Heading;                // ADF2 directional vector
	float           autopilotHeading;           // AP heading-mode selcted heading
    BOOL            autopilotHeadingModeEnabled;// AP heading-mode on/off state
	float           compassHeading;             // current magnetic compass heading
    float           crossTrackError;
    //
    // The lateral deviation left or right of the active flight plan course.  It
    // is displayed next to the aricraft symbol in nautical miles.
    //
    float           glideSlopeDeviation;
    BOOL            glideSlopeEnabled;
    //
    // When the ND is in ILS-ROSE mode, the glide-slope scale is on.  When the
    // localizer is in range, the glide-slope indicator diamond is displayed on
    // the scale.  This property indicates whether or not the glice-slope scale
    // and indicator should be visible.
    //
    float           groundSpeed;                // current ground speed
    NDModeEnum      mode;                       // ND master mode
    float           navCourse;
    //
    // When one of the navigation modes (ILS-ROSE or NAV-ROSE) is active, this
    // property indicates the selected ILS-localizer or VOR-radial course that
    // has been selected by the pilot.
    //
    float           navCourseDeviation;
    //
    // Number of degrees left or right (plus or minus, respectively) we are
    // deviation from the currently selected course.
    //
    NDNavModeEnum   navMode;                    // navigation mode (off, NAV, ILS)
    NDRangeEnum     range;
    //
    // Each mode of the ND is capable of displaying an range scale from 10 to
    // 320 nautical miles, selected on the EFIS control panel.  The maximum range
    // from the aircraft position in the rose modes is half the selected range.
    // In the ARC mode, the range from the aircraft position to the outer edge
    // of the scale is equal to the selected range.
    //
    float           track;                      // current aircraft track
    //
    // Represented by a green diamond indicates the aircraft's actual track as
    // opposed to the AP heading or the magnetic compass heading.
    //
    float           trueAirSpeed;               // current air speed
    BOOL            vor1Enabled;                // VOR1 on/off state
    float           vor1Heading;                // VOR1 selected radial
    BOOL            vor2Enabled;                // VOR2 on/off state
    float           vor2Heading;                // VOR2 selected radial
    float           windDirection;
    float           windSpeed;
}

@property(nonatomic) BOOL           adf1Enabled;
@property(nonatomic) float          adf1Heading;
@property(nonatomic) BOOL           adf2Enabled;
@property(nonatomic) float          adf2Heading;
@property(nonatomic) float          autopilotHeading;
@property(nonatomic) BOOL           autopilotHeadingModeEnabled;
@property(nonatomic) float          compassHeading;
@property(nonatomic) float          glideSlopeDeviation;
@property(nonatomic) BOOL           glideSlopeEnabled;
@property(nonatomic) float          groundSpeed;
@property(nonatomic) NDModeEnum     mode;
@property(nonatomic) float          navCourse;
@property(nonatomic) float          navCourseDeviation;
@property(nonatomic) NDNavModeEnum  navMode;
@property(nonatomic) NDRangeEnum    range;
@property(nonatomic) float          track;
@property(nonatomic) float          trueAirSpeed;
@property(nonatomic) BOOL           vor1Enabled;
@property(nonatomic) float          vor1Heading;
@property(nonatomic) BOOL           vor2Enabled;
@property(nonatomic) float          vor2Heading;
@property(nonatomic) float          windDirection;
@property(nonatomic) float          windSpeed;

@end
