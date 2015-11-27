/*
 *  XPlaneData.h
 *  AirbusND
 *
 *  Created by Michael A. Crawford on 1/24/09.
 *  Copyright 2009 Crawford Design Engineering, Inc. All rights reserved.
 *
 *  NOTE:  These definitions are current as of X-Plane version 9.
 *
 */
#ifndef _XPLANE_DATA_H_
#define _XPLANE_DATA_H_

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#pragma pack(push,1)

#ifndef LITTLE_ENDIAN
#define LITTLE_ENDIAN 1
#endif

//
// XPlaneMesgType constants are reverse byte order for little-endian (Intel)
// machines.
//
#if defined(BIG_ENDIAN)
typedef enum XPlaneMesgType {
    kDATA = 'DATA',
    kDSEL = 'DSEL',
    kUSEL = 'USEL',
    kDCOC = 'DCOC',
    kUCOC = 'UCOC',
    kMOUS = 'MOUS',
    kCHAR = 'CHAR',
    kMENU = 'MENU',
    kSOUN = 'SOUN',
    kDREF = 'DREF',
    kFAIL = 'FAIL',
    kRECO = 'RECO',
    kPAPT = 'PAPT',
    kVEHN = 'VEHN',
    kVEH1 = 'VEH1',
    kVEHA = 'VEHA',
    kOBJN = 'OBJN',
    kOBJL = 'OBJL',
    kGSET = 'GSET',
    kISET = 'ISET',
    kBOAT = 'BOAT'
} XPLANE_MESG_TYPE;
#elif defined(LITTLE_ENDIAN)
typedef enum XPlaneMesgType {
    kDATA = 'ATAD',
    kDSEL = 'LESD',
    kUSEL = 'LESU',
    kDCOC = 'COCD',
    kUCOC = 'COCU',
    kMOUS = 'SUOM',
    kCHAR = 'RAHC',
    kMENU = 'UNEM',
    kSOUN = 'NUOS',
    kDREF = 'FERD',
    kFAIL = 'LIAF',
    kRECO = 'OCER',
    kPAPT = 'TPAP',
    kVEHN = 'NHEV',
    kVEH1 = '1HEV',
    kVEHA = 'AHEV',
    kOBJN = 'NJBO',
    kOBJL = 'LJBO',
    kGSET = 'TESG',
    kISET = 'TESI',
    kBOAT = 'TAOB'
} XPLANE_MESG_TYPE;
#else
#error "Endian-ness is not defined"
#endif

typedef enum XPlaneDataTypeIndex {
    kFrameRate                              = 0,
    kTimes                                  = 1,
    kSimStats                               = 2,
    kSpeeds                                 = 3,
    kMachVVIGLoad                           = 4,
    kAtmosphereWeather                      = 5,
    kAtmosphereAircraft                     = 6,
    kSystemPressure                         = 7,
    kJoystickAileronElevatorRudder          = 8,
    kOtherFlightControls                    = 9,
    kArtificialStabAileronElevatorRudder    = 10,
    kFlightControlAileronElevatorRudder     = 11,
    kWingSweepThrustVector                  = 12,
    kTrimFlapSlatSpeedBrakes                = 13,
    kGearBrakes                             = 14,
    kAngularMoments                         = 15,
    kAngularAccelerations                   = 16,
    kAngularVelocities                      = 17,
    kPitchRollHeadings                      = 18,
    kAOASideSlip                            = 19,
    kLatitudeLongitudeAltitude              = 20,
    kLocationVelocityDistanceTraveled       = 21,
    kAllPlanesLatitude                      = 22,
    kAllPlanesLongitude                     = 23,
    kAllPlanesAlitiude                      = 24,
    kThrottleCommand                        = 25,
    kThrottleActual                         = 26,
    kFeatherNormBetaReverse                 = 27,
    kPropSetting                            = 28,
    kMixtureSetting                         = 29,
    kCarbHeatSetting                        = 30,
    kCowlFlapSetting                        = 31,
    kIgnitionSetting                        = 32,
    kStarterTimeout                         = 33,
    kEnginePower                            = 34,
    kEngineThrust                           = 35,
    kEngineTorque                           = 36,
    kEngineRPM                              = 37,
    kPropRPM                                = 38,
    kPropPitch                              = 39,
    kPropWashJetWash                        = 40,
    kN1                                     = 41,
    kN2                                     = 42,
    kMP                                     = 43,
    kEnginePerformanceRating                = 44,
    kFF                                     = 45,
    kITT                                    = 46,
    kExaustGasTemperature                   = 47,
    kCHT                                    = 48,
    kOilPressure                            = 49,
    kOilTemp                                = 50,
    kFuelPressure                           = 51,
    kGeneratorAmperage                      = 52,
    kBatteryAmperage                        = 53,
    kBatteryVoltage                         = 54,
    kFuelPumpSwitch                         = 55,
    kIdleSpeedLowHigh                       = 56,
    kBatterySwitch                          = 57,
    kGeneratorSwitch                        = 58,
    kInverterSwitch                         = 59,
    kFADECSwitch                            = 60,
    kIgniterSwitch                          = 61,
    kFuelWeights                            = 62,
    kPayloadWeightsCG                       = 63,
    kAeroForces                             = 64,
    kEngineForces                           = 65,
    kLangingGearVerticalForce               = 66,
    kLandingGearDeployment                  = 67,
    kLiftOverDragAndCoefficients            = 68,
    kPropEfficiency                         = 69,
    kDefsAilerons1                          = 70,
    kDefsAilerons2                          = 71,
    kDefsRollSpoilers1                      = 72,
    kDefsRollSpoilers2                      = 73,
    kDefsElevators                          = 74,
    kDefsRudders                            = 75,
    kDefsYawBrakes                          = 76,
    kControlForces                          = 77,
    kTotalVerticalThrustVectors             = 78,
    kTotalLateralThrustVectors              = 79,
    kPitchCyclicDiskTilts                   = 80,
    kRollCyclicDiskTilts                    = 81,
    kPitchCyclicFlapping                    = 82,
    kRollCyclicFlapping                     = 83,
    kGroundEffectLiftWings                  = 84,
    kGroundEffectDragWings                  = 85,
    kGroundEffectWashWings                  = 86,
    kGroundEffectLiftStabilizers            = 87,
    kGroundEffectDragStabilizers            = 88,
    kGroundEffectWashStabilizers            = 89,
    kGroundEffectLiftProps                  = 90,
    kGroundEffectDragProps                  = 91,
    kWingLift                               = 92,
    kWingDrag                               = 93,
    kStabilizerLift                         = 94,
    kStabilizerDrag                         = 95,
    kCOM1And2Frequencies                    = 96,
    kNAV1And2Frequencies                    = 97,
    kNAV1And2OBS                            = 98,
    kNAV1And2Deflections                    = 99,
    kADF1And2Status                         = 100,
    kDMEStatus                              = 101,
    kGPSStatus                              = 102,
    kTransponderStatus                      = 103,
    kMarkerStatus                           = 104,
    kElectricalSwitches                     = 105,
    kEFISSwitches                           = 106,
    kAutoPilotFlightDirectorHUDSwitches     = 107,
    kAntiIceSwitches                        = 108,
    kAntiIceAndFuelSwitches                 = 109,
    kClutchAndAStabilizerSwitches           = 110,
    kMiscellaneousSwitches                  = 111,
    kGeneralAnnunciators                    = 112,
    kEngineAnnunciators                     = 113,
    kAutoPilotArms                          = 114,
    kAutoPilotModes                         = 115,
    kAutoPilotValues                        = 116,
    kWeaponStatus                           = 117,
    kPressurizationStatus                   = 118,
    kAPIGPUStatus                           = 119,
    kRadarStatus                            = 120,
    kHydrolicStatus                         = 121,
    kElectricAndSolarStatus                 = 122,
    kIcingStatus                            = 123,
    kWarningStatus                          = 124,
    kFlightPlanLegs                         = 125,
    kHardwareOptions                        = 126,
    kCameraLocation                         = 127,
    kGroundLocation                         = 128
} XPLANE_DATA_TYPE;

typedef struct XPlaneMessageHeader {
    uint32_t    msgType;
    uint8_t     index;
} XPLANE_MESG_HEADER;

typedef struct XPlaneGenericData {
    uint32_t data0;
    uint32_t data1;
    uint32_t data2;
    uint32_t data3;
    uint32_t data4;
    uint32_t data5;
    uint32_t data6;
    uint32_t data7;
} XPLANE_GENERIC_DATA;

typedef struct XPlaneOrientationData {
    float       pitch;
    float       roll;
    float       heading;
    float       magneticHeading;
    float       magneticVariation;
    float       headingBug;
    uint32_t    unused;
    uint32_t    unused1;
} XPLANE_ORIENTATION_DATA;

typedef struct XPlaneVelocityData {
    float       trueAirSpeedKnots;
    float       indicatedAirSpeedKnots;
    float       trueAirSpeedMPH;
    float       indicatedAirSpeedMPH;
    uint32_t    unused;
    float       groundSpeedKnots;
    float       groundSpeedMPH;
} XPLANE_VELOCITY_DATA;

typedef struct XPlaneIndexAndData {
    uint32_t                    index;
    union {
        XPLANE_GENERIC_DATA     generic;
        XPLANE_ORIENTATION_DATA orientation;
        XPLANE_VELOCITY_DATA    velocity;
    } u;
} XPLANE_DATA;
    
typedef struct XPlaneDataMessage {
    XPLANE_MESG_HEADER  header;
    XPLANE_DATA         data;
} XPLANE_DATA_MESG;

typedef struct XPlaneDataSelectMessage {
    XPLANE_MESG_HEADER  header;
    uint32_t            ipAddress;
    uint32_t            index;
    uint32_t            data[8];
} XPLANE_DSEL_MESG;

typedef struct XPlaneDataUnSelectMessage {
    XPLANE_MESG_HEADER  header;
    uint32_t            ipAddress;
    uint32_t            data[8];
} XPLANE_USEL_MESG;

#pragma pack(pop)

static __inline__ XPLANE_DSEL_MESG
MakeXPlaneDataSelectMessage(uint32_t ipAddress, uint32_t data)
{
    XPLANE_DSEL_MESG message;
    message.header.msgType  = kDSEL;
    message.header.index    = 0;
    message.ipAddress       = ipAddress;
    message.data[0]         = data;
    return message;
}
    
#ifdef __cplusplus
};
#endif

#endif /* _XPLANE_DATA_H_ */
