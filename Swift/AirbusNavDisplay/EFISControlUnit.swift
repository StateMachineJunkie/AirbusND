//
//  EFISControlUnit.swift
//  AirbusNavDisplay
//
//  Created by Michael A. Crawford on 12/22/15.
//  Copyright © 2015 Crawford Design Engineering, LLC. All rights reserved.
//

import UIKit

@objc final class EFISControlUnit: NSObject {

    enum Mode {
        case arc
        case roseILS
        case roseNAV
        case roseVOR
    }
    
    enum NavaidSource {
        case off
        case adf
        case vor
    }
    
    enum Range: Int {
        case ten            = 10
        case twenty         = 20
        case forty          = 40
        case eighty         = 80
        case oneSixty       = 160
        case threeTwenty    = 320
    }
    
    dynamic var displayAirports: Bool = false       // ARPT button
    dynamic var displayRoute: Bool = false          // CSTR button
    dynamic var displayWaypoints: Bool = false      // WPT button
    dynamic var displayVORStations: Bool = false    // VOR.D button
    dynamic var displayNDBStations: Bool = false    // NDB button
    dynamic var mode: Mode = .roseNAV
    dynamic var navaid1Source: NavaidSource = .off
    dynamic var navaid2Source: NavaidSource = .off
    dynamic var range: Range = .ten
}
