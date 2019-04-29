//
//  NDViewController.swift
//  AirbusNavDisplay
//
//  Created by Michael A. Crawford on 11/26/15.
//  Copyright © 2015 Crawford Design Engineering, LLC. All rights reserved.
//

import UIKit

class NDViewController: UIViewController {

    private var debugTimer: Timer?
    private let ECU: EFISControlUnit = EFISControlUnit()
    
    // MARK: - Initialization
    override init(nibName: String?, bundle nibBundle: Bundle?) {
        super.init(nibName: nibName, bundle: nibBundle)
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        // Debug
        #if false
        let ndView = self.view as! NDView
        ndView.ADF1Enabled = true
        debugTimer = Timer.scheduledTimer(timeInterval: 0.033, target: self, selector: #selector(NDViewController.debugTick), userInfo: nil, repeats: true)
        #endif
    }
    
    // MARK: - View Lifecycle Methods
    override func loadView() {
        self.view = NDView()
    }
    
    // MARK: - Public Methods
    func incrementMode() {
        guard let ndView = self.view as? NDView else { return }
        
        switch ( ECU.mode ) {
        case .arc:
            ECU.mode = .roseILS
            ndView.radioNAVSource = .ils
        case .roseILS:
            ECU.mode = .roseVOR
            ndView.radioNAVSource = .vor
        case .roseVOR:
            ECU.mode = .roseNAV
            ndView.radioNAVSource = .off
        case .roseNAV:
            ECU.mode = .arc
            ndView.radioNAVSource = .off
        }
    }
    
    func incrementNav1Source() {
        guard let ndView = self.view as? NDView else { return }
        
        switch ( ECU.navaid1Source ) {
        case .adf:
            ECU.navaid1Source = .vor
            ndView.ADF1Enabled = false
            ndView.VOR1Enabled = true
        case .off:
            ECU.navaid1Source = .adf
            ndView.ADF1Enabled = true
            ndView.VOR1Enabled = false
        case .vor:
            ECU.navaid1Source = .off
            ndView.ADF1Enabled = false
            ndView.VOR1Enabled = false
        }
    }
    
    func incrementNav2Source() {
        guard let ndView = self.view as? NDView else { return }
        
        switch ( ECU.navaid2Source ) {
        case .adf:
            ECU.navaid2Source = .vor
            ndView.ADF2Enabled = false
            ndView.VOR2Enabled = true
        case .off:
            ECU.navaid2Source = .adf
            ndView.ADF2Enabled = true
            ndView.VOR2Enabled = false
        case .vor:
            ECU.navaid2Source = .off
            ndView.ADF2Enabled = false
            ndView.VOR2Enabled = false
        }
    }
    
    func incrementRange() {
        guard let ndView = self.view as? NDView else { return }
        
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
        
        ndView.range = ECU.range.rawValue
    }
    
    func startBIT(_ completion: @escaping BITCompletion) {
        if let navigationDisplayView = self.view as? NDView {
            navigationDisplayView.startBIT(completion)
        }
    }
    
    @objc func debugTick() {
        let ndView = self.view as! NDView
        var newHeading = ndView.ADF1Heading - 1.0
        if newHeading < Angle.min.degrees {
            newHeading += 360.0
        }
        ndView.ADF1Heading = newHeading
        ndView.compassHeading += 1.0
    }
}

