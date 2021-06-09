//
//  XPlaneService.swift
//  AirbusNavDisplay
//
//  Created by Michael A. Crawford on 5/13/19.
//  Copyright © 2019 Crawford Design Engineering, LLC. All rights reserved.
//

import DataDecoder
import Foundation

extension Data {
    func decode() throws -> DataRef {
        return DataRef(id: 0, value: 0.0)
    }
    
    func decode() throws -> DataRefs {
        return DataRefs(datarefs: [DataRef(id: 0, value: 0.0)])
    }
    
    func decode() throws -> PositionUpdate {
        
        return PositionUpdate(longitude: 0.0,
                              latitude: 0.0,
                              elevation: Measurement(value: 0.0, unit: UnitLength.meters),
                              agl: Measurement(value: 0.0, unit: UnitLength.meters),
                              pitch: Measurement(value: 0.0, unit: UnitAngle.degrees),
                              trueHeading: Measurement(value: 0.0, unit: UnitAngle.degrees),
                              roll: Measurement(value: 0.0, unit: UnitAngle.degrees),
                              speedX: Measurement(value: 0.0, unit: UnitSpeed.metersPerSecond),
                              speedY: Measurement(value: 0.0, unit: UnitSpeed.metersPerSecond),
                              speedZ: Measurement(value: 0.0, unit: UnitSpeed.metersPerSecond),
                              rollRate: Measurement(value: 0.0, unit: UnitSpeed.metersPerSecond),
                              pitchRate: Measurement(value: 0.0, unit: UnitSpeed.metersPerSecond),
                              yawRate: Measurement(value: 0.0, unit: UnitSpeed.metersPerSecond))
    }
}

// sim/cockpit/radios/
// sim/cockpit/switches/

enum DataRefId: UInt32, Codable {
    case adf1_dme_dist_m                // Our distance in nautical miles from the ADF 1 beacon
    case adf2_dme_dist_m                // Our distance in nautical miles from the ADF 2 beacon
    case nav_type                       // Type of NAVAID that is tuned in
    case nav1_CDI                       // Are we receiving GS for nav 1
    case nav1_dme_dist_m                // Our distance in nautical miles from the nav 1 beacon
    case nav1_fromto                    // Whether we are heading to or from our nav 1 beacon
    case nav1_obs_degm                  // The OBS heading for VOR and HSI following nav radio 1
    case nav1_vdef_deg                  // Nav 1 glide slope deflection in degrees
    case nav1_vdef_dot                  // Nav 1 ILS glide deflection in degrees
    case nav2_CDI                       // Are we receiving gs for nav 2
    case nav2_dem_dist_m                // Our distance in nautical miles from the nav 2 beacon
    case nav2_fromto                    // Whether we are heading to or from our nav 2 beacon
    case nav2_obs_degm                  // The OBS heading for VOR and HSI following nav radio 2
    case nav2_vdef_deg                  // Nav 2 glide slope deflection in degrees
    case nav2_vdef_dot                  // Nav 1 ILS glide deflection in degrees
}

enum DataRefName: String, Codable {
    case adf1_dme_dist_m                // Our distance in nautical miles from the ADF 1 beacon
    case adf2_dme_dist_m                // Our distance in nautical miles from the ADF 2 beacon
    case nav_type                       // Type of NAVAID that is tuned in
    case nav1_CDI                       // Are we receiving GS for nav 1
    case nav1_dme_dist_m                // Our distance in nautical miles from the nav 1 beacon
    case nav1_fromto                    // Whether we are heading to or from our nav 1 beacon
    case nav1_obs_degm                  // The OBS heading for VOR and HSI following nav radio 1
    case nav1_vdef_deg                  // Nav 1 glide slope deflection in degrees
    case nav1_vdef_dot                  // Nav 1 ILS glide deflection in degrees
    case nav2_CDI                       // Are we receiving gs for nav 2
    case nav2_dem_dist_m                // Our distance in nautical miles from the nav 2 beacon
    case nav2_fromto                    // Whether we are heading to or from our nav 2 beacon
    case nav2_obs_degm                  // The OBS heading for VOR and HSI following nav radio 2
    case nav2_vdef_deg                  // Nav 2 glide slope deflection in degrees
    case nav2_vdef_dot                  // Nav 1 ILS glide deflection in degrees
}

struct DataRefRequest: Encodable {
    let name = "RREF"
    let frequency: Measurement<UnitFrequency>
    let id: UInt32
    let dataref: String
    
    func encode() throws -> Data {
        var bytes = [UInt8]()
        bytes.append(contentsOf: name.utf8)
        bytes.append(0)
        bytes.append(contentsOf: String(frequency.value).utf8)
        bytes.append(0)
        return Data()
    }
}

struct DataRef: Decodable {
    let id: UInt32
    let value: Float
}

struct DataRefs: Decodable {
    let name = "RREF"
    let datarefs: [DataRef]
}

struct PositionRequest: Encodable {
    let name = "RPOS"
    let frequency: Measurement<UnitFrequency> = Measurement(value: 5.0, unit: UnitFrequency.hertz)
    
    func encode() throws -> Data {
        var bytes = [UInt8]()
        bytes.append(contentsOf: name.utf8)
        bytes.append(0)
        bytes.append(contentsOf: String(frequency.value).utf8)
        bytes.append(0)
        return Data(bytes: &bytes, count: bytes.count)
    }
}

struct PositionUpdate: Decodable {
    let name = "RPOS"
    let longitude: Double
    let latitude: Double
    let elevation: Measurement<UnitLength>          // meters above sealevel
    let agl: Measurement<UnitLength>                // meters above ground level
    let pitch: Measurement<UnitAngle>               // pitch angle in degrees
    let trueHeading: Measurement<UnitAngle>         // heading in degrees
    let roll: Measurement<UnitAngle>                // rool angle in degrees
    let speedX: Measurement<UnitSpeed>       // speed in the X, East, direction.
    let speedY: Measurement<UnitSpeed>       // speed in the Y, UP, direction.
    let speedZ: Measurement<UnitSpeed>       // speed in the Z, South, direction.
    let rollRate: Measurement<UnitSpeed>     // roll-rate in meters per second.
    let pitchRate: Measurement<UnitSpeed>    // pitch-rate in meters per second.
    let yawRate: Measurement<UnitSpeed>      // yaw-rate in meters per second.
}

struct XPlaneProxy {
    var updatesPerSecond: Measurement<UnitFrequency> = Measurement(value: 20.0, unit: UnitFrequency.hertz)
    var isPositionUpdateEnabled: Bool = false
}

class XPlaneMock {
    // TODO: sends and receives data normally transported in UDP packets
}
