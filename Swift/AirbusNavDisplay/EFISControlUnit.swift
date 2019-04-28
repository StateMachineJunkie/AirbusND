//
//  EFISControlUnit.swift
//  AirbusNavDisplay
//
//  Created by Michael A. Crawford on 12/22/15.
//  Copyright © 2015 Crawford Design Engineering, LLC. All rights reserved.
//

import UIKit

class EFISControlUnit: NSObject {

    enum Mode {
        case arc
        case rose(submode: RoseSubmodes)
        case plan
        
        enum RoseSubmodes {
            case ils
            case nav
            case vor
        }
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
    
    var displayAirports: Bool = false       // ARPT button
    var displayRoute: Bool = false          // CSTR button
    var displayWaypoints: Bool = false      // WPT button
    var displayVORStations: Bool = false    // VOR.D button
    var displayNDBStations: Bool = false    // NDB button
    var mode: Mode = .rose(submode: .nav)
    var navaid1Source: NavaidSource = .off
    var navaid2Source: NavaidSource = .off
    var range: Range = .ten
}
