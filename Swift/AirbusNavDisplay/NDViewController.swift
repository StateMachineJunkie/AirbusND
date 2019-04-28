//
//  NDViewController.swift
//  AirbusNavDisplay
//
//  Created by Michael A. Crawford on 11/26/15.
//  Copyright © 2015 Crawford Design Engineering, LLC. All rights reserved.
//

import UIKit

class NDViewController: UIViewController {

    let ECU: EFISControlUnit = EFISControlUnit()
    var debugTimer: Timer?
    
    // MARK: - Initialization
    override init(nibName: String?, bundle nibBundle: Bundle?) {
        super.init(nibName: nibName, bundle: nibBundle)
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        // Debug
        let ndView = self.view as! NDView
        ndView.ADF1Enabled = true
        debugTimer = Timer.scheduledTimer(timeInterval: 0.33, target: self, selector: #selector(NDViewController.debugTick), userInfo: nil, repeats: true)
    }
    
    // MARK: - View Lifecycle Methods
    override func loadView() {
        self.view = NDView()
    }
    
    // MARK: - KVO Handlers
    @objc func rangeChanged() {
        if let view = self.view as? NDView {
            view.range = ECU.range.rawValue
        }
    }
    
    // MARK: - Public Methods
    func incrementMode() {
        switch ( ECU.mode ) {
        case .arc:
            ECU.mode = .plan
        case .plan:
            ECU.mode = .rose(submode: .ils)
        case .rose(submode: .ils):
            ECU.mode = .rose(submode: .vor)
        case .rose(submode: .vor):
            ECU.mode = .rose(submode: .nav)
        case .rose(submode: .nav):
            ECU.mode = .arc
        }
    }
    
    func incrementNav1Source() {
        switch ( ECU.navaid1Source ) {
        case .adf:
            ECU.navaid1Source = .vor
        case .off:
            ECU.navaid1Source = .adf
        case .vor:
            ECU.navaid1Source = .off
        }
    }
    
    func incrementNav2Source() {
        switch ( ECU.navaid2Source ) {
        case .adf:
            ECU.navaid2Source = .vor
        case .off:
            ECU.navaid2Source = .adf
        case .vor:
            ECU.navaid2Source = .off
        }
    }
    
    func incrementRange() {
        switch ( ECU.range ) {
        case .ten:
            ECU.range = .twenty
        case .twenty:
            ECU.range = .forty
        case .forty:
            ECU.range = .eighty
        case .eighty:
            ECU.range = .oneSixty
        case .oneSixty:
            ECU.range = .threeTwenty
        case .threeTwenty:
            ECU.range = .ten
        }
    }
    
    func startBIT(_ completion: @escaping BITCompletion) {
        if let navigationDisplayView = self.view as? NDView {
            navigationDisplayView.startBIT(completion)
        }
    }
    
    @objc func debugTick() {
        let ndView = self.view as! NDView
        print("ADF1=\(ndView.ADF1Heading), compass=\(ndView.compassHeading)")
        var newHeading = ndView.ADF1Heading - 1.0
        if newHeading < Angle.min.degrees {
            newHeading += 360.0
        }
        ndView.ADF1Heading = newHeading
        ndView.compassHeading += 1.0
    }
}

