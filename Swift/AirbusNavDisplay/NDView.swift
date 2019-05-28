//
//  NDView.swift
//  AirbusNavDisplay
//
//  Created by Michael A. Crawford on 11/26/15.
//  Copyright © 2015 Crawford Design Engineering, LLC. All rights reserved.
//

import UIKit

// There are a couple of policies in place with the heading properties. If the
// input value is a fraction of a degree it is rounded to the nearest integer.
// All input and output are assimed to be in degrees not radians. If an input
// value is not in range (0 <= x <= 360), it will ge silently ignored

typealias BITCompletion = (Bool) -> Void

@IBDesignable class NDView: UIView {
    
    var disableAnimations = false
    
    @objc public enum RadioNAVSource: Int {
        case off
        case ils
        case vor
    }
    
    private let kRateOfRotation: CGFloat = 20.0
    
    /// `CALayer` displaying the ADF1 needle.
    private var adf1Layer: ADF1Layer = {
        let layer = ADF1Layer()
        layer.name = "ADF1"
        layer.isHidden = true
        return layer
    }()
    
    /// `CALayer` displaying the ADF2 needle.
    private var adf2Layer: ADF2Layer = {
        let layer = ADF2Layer()
        layer.name = "ADF2"
        layer.isHidden = true
        return layer
    }()
    
    /// `CALayer` displaying the aircraft datum and heading indicator.
    private var aircraftDatumLayer: AircraftDatumLayer = {
        let layer = AircraftDatumLayer()
        layer.name = "AC Datum"
        return layer
    }()
    
    /// `CALayer` displaying the autopilot heading bug.
    private var autopilotHeadingLayer: AutopilotHeadingLayer = {
        let layer = AutopilotHeadingLayer()
        layer.name = "AP Heading"
        return layer
    }()
    
    /// `CALayer` displaying the compass-rose.
    private var compassLayer: CompassRoseLayer = {
        let layer = CompassRoseLayer()
        layer.name = "Compass Rose"
        return layer
    }()
    
    /// `CALayer` displaying the the fixed (non-moving) components of the ND.
    private var fixedComponentsLayer: FixedComponentsLayer = {
        let layer = FixedComponentsLayer()
        layer.name = "Fixed Components"
        return layer
    }()
    
    /// `CALayer` displaying the ILS/VOR course and course-deviation needles.
    private var navLayer: NavLayer = {
        let layer = NavLayer()
        layer.name = "Nav"
        layer.isHidden = true
        return layer
    }()
    
    /// `CALayer` displaying the VOR1 needle.
    private var vor1Layer: VOR1Layer = {
        let layer = VOR1Layer()
        layer.name = "VOR1"
        layer.isHidden = true
        return layer
    }()
    
    /// `CALayer` displaying the VOR2 needle.
    private var vor2Layer: VOR2Layer = {
        let layer = VOR2Layer()
        layer.name = "VOR2"
        layer.isHidden = true
        return layer
    }()
    
    private var bitCompletion: BITCompletion?
    private var bitInProgress = false
    
    private var layoutBounds: CGRect = CGRect.zero
    
    // MARK: - Properties
    @IBInspectable var ADF1Enabled: Bool {
        get {
            return !adf1Layer.isHidden
        }
        set(newValue) {
            adf1Layer.isHidden = !newValue
        }
    }
    
    @IBInspectable var ADF1Heading: CGFloat {
        get {
            var heading = (CGAffineTransform(fullTransform: adf1Layer.transform).rotationAngle).degrees
            if heading < Angle.min.degrees {
                heading += Angle.rev
            }
            return round(heading)
        }
        set(newHeading) {
            if  newHeading >= Angle.min.degrees && newHeading <= Angle.max.degrees {
                adf1Layer.transform = CATransform3DMakeRotation(round(newHeading).radians, 0, 0, 1)
            }
        }
    }
    
    @IBInspectable var ADF2Enabled: Bool {
        get {
            return !adf2Layer.isHidden
        }
        set(newValue) {
            adf2Layer.isHidden = !newValue
        }
    }
    
    @IBInspectable var ADF2Heading: CGFloat {
        get {
            var heading = (CGAffineTransform(fullTransform: adf2Layer.transform).rotationAngle).degrees
            if heading < Angle.min.degrees {
                heading += Angle.rev
            }
            return round(heading)
        }
        set(newHeading) {
            if  newHeading >= 0 && newHeading <= 360 {
                adf2Layer.transform = CATransform3DMakeRotation(round(newHeading).radians, 0, 0, 1)
            }
        }
    }
    
    @IBInspectable var autopilotHeading: CGFloat {
        get {
            var heading = (CGAffineTransform(fullTransform: autopilotHeadingLayer.transform).rotationAngle).degrees
            if heading < Angle.min.degrees {
                heading += Angle.rev
            }
            return round(heading)
        }
        set(newHeading) {
            if  newHeading >= Angle.min.degrees && newHeading <= Angle.rev {
                autopilotHeadingLayer.transform = CATransform3DMakeRotation(round(newHeading).radians, 0, 0, 1)
            }
        }
    }
    
    @IBInspectable var autopilotHeadingEnabled: Bool {
        get {
            return !autopilotHeadingLayer.isHidden
        }
        set(newValue) {
            autopilotHeadingLayer.isHidden = !newValue
        }
    }
    
    @IBInspectable var compassHeading: CGFloat {
        get {
            var heading = (CGAffineTransform(fullTransform: compassLayer.transform).rotationAngle).degrees
            if heading < Angle.min.degrees {
                heading += Angle.rev
            }
            return round(heading)
        }
        set(newHeading) {
            if newHeading >= Angle.min.degrees && newHeading <= Angle.rev {
                compassLayer.transform = CATransform3DMakeRotation(round(newHeading).radians, 0, 0, 1)
            }
        }
    }
    
    @IBInspectable var radioNAVCourse: CGFloat {
        get {
            var heading = (CGAffineTransform(fullTransform: navLayer.transform).rotationAngle).degrees
            if heading < Angle.min.degrees {
                heading += Angle.rev
            }
            return round(heading)
        }
        set(newHeading) {
            if  newHeading >= Angle.min.degrees && newHeading <= Angle.rev {
                navLayer.transform = CATransform3DMakeRotation(round(newHeading).radians, 0, 0, 1)
            }
        }
    }
    
    @IBInspectable var radioNAVCourseDeviation: CGFloat {
        get {
            return navLayer.courseDeviation
        }
        set(newDeviation) {
            navLayer.courseDeviation = newDeviation
        }
    }
    
    @IBInspectable var radioNAVGlideSlopeDeviation: CGFloat {
        get {
            return fixedComponentsLayer.glideSlopeDeviation
        }
        set(newDeviation) {
            fixedComponentsLayer.glideSlopeDeviation = newDeviation
        }
    }
    
    @IBInspectable var radioNAVSource: RadioNAVSource {
        get {
            if navLayer.isHidden {
                return .off
            } else if navLayer.drawILS {
                return .ils
            } else {
                return .vor
            }
        }
        set(newValue) {
            switch newValue {
            case .off:
                navLayer.isHidden = true
                fixedComponentsLayer.glideSlopeEnabled = false
                
            case .ils, .vor:
                navLayer.isHidden = false
                
                if .ils == newValue {
                    navLayer.drawILS = true
                    fixedComponentsLayer.glideSlopeEnabled = true
                } else {
                    navLayer.drawILS = false
                    fixedComponentsLayer.glideSlopeEnabled = false
                }
            }
        }
    }
    
    @IBInspectable var range: Int {
        get {
            return fixedComponentsLayer.range
        }
        set(newRange) {
            fixedComponentsLayer.range = newRange
        }
    }
    
    @IBInspectable var VOR1Enabled: Bool {
        get {
            return !vor1Layer.isHidden
        }
        set(newValue) {
            vor1Layer.isHidden = !newValue
        }
    }
    
    @IBInspectable var VOR1Heading: CGFloat {
        get {
            var heading = (CGAffineTransform(fullTransform: vor1Layer.transform).rotationAngle).degrees
            if heading < Angle.min.degrees {
                heading += Angle.rev
            }
            return round(heading)
        }
        set(newHeading) {
            if  newHeading >= Angle.min.degrees && newHeading <= Angle.rev {
                vor1Layer.transform = CATransform3DMakeRotation(round(newHeading).radians, 0, 0, 1)
            }
        }
    }

    @IBInspectable var VOR2Enabled: Bool {
        get {
            return !vor2Layer.isHidden
        }
        set(newValue) {
            vor2Layer.isHidden = !newValue
        }
    }
    
    @IBInspectable var VOR2Heading: CGFloat {
        get {
            var heading = (CGAffineTransform(fullTransform: vor2Layer.transform).rotationAngle).degrees
            if heading < Angle.min.degrees {
                heading += Angle.rev
            }
            return round(heading)
        }
        set(newHeading) {
            if  newHeading >= Angle.min.degrees && newHeading <= Angle.rev {
                vor2Layer.transform = CATransform3DMakeRotation(round(newHeading).radians, 0, 0, 1)
            }
        }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.backgroundColor = UIColor.black.cgColor
        self.layer.delegate = self
        
        // The ADf, NAV, and VOR layers should move relative to the compass-rose
        self.compassLayer.sublayers = [
            adf1Layer,
            adf2Layer,
            vor1Layer,
            vor2Layer,
            navLayer,
            autopilotHeadingLayer
        ]
        
        // Add layers in order to be displayed
        self.layer.sublayers = [
            fixedComponentsLayer,
            compassLayer,
            aircraftDatumLayer
        ]
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CALayer Delegate Methods
    override func layoutSublayers(of layer: CALayer) {
        // Update sublayer frames based on new view size but only if the view
        // size has changed since the last layout request. Since we receive
        // layout requests for other reasons than a resize event, this is an
        // optimization.
        if false == layer.bounds.equalTo(layoutBounds) {
            layoutBounds = layer.bounds
            
            fixedComponentsLayer.frame      = layer.bounds
            compassLayer.bounds             = layer.bounds
            aircraftDatumLayer.frame        = layer.bounds
            
            adf1Layer.bounds                = compassLayer.bounds
            adf2Layer.bounds                = compassLayer.bounds
            autopilotHeadingLayer.bounds    = compassLayer.bounds
            navLayer.bounds                 = compassLayer.bounds
            vor1Layer.bounds                = compassLayer.bounds
            vor2Layer.bounds                = compassLayer.bounds
            
            compassLayer.position = CGPoint(x: layer.bounds.midX, y: layer.bounds.midY)
            
            // For this center-point to be calculated properly, the new bounds
            // value for the compass layer must be set.
            let centerPoint = CGPoint(x: compassLayer.bounds.midX, y: compassLayer.bounds.midY)
            
            adf1Layer.position              = centerPoint
            adf2Layer.position              = centerPoint
            autopilotHeadingLayer.position  = centerPoint
            navLayer.position               = centerPoint
            vor1Layer.position              = centerPoint
            vor2Layer.position              = centerPoint
            
            // use newly computed radius to determine the corner radius for this view
            self.layer.cornerRadius = compassLayer.radius * 0.40
        }
    }
    
    // MARK: - Public Methods
    func startBIT(_ completion: @escaping (_ finished: Bool) -> Void) {
        if bitInProgress {
            completion(false)
            return
        }
        
        bitCompletion = completion
        bitInProgress = true
        
        self.ADF1Enabled = true
        self.ADF2Enabled = true
        self.autopilotHeadingEnabled = true
        self.radioNAVSource = .ils
        self.VOR1Enabled = true
        self.VOR2Enabled = true
        
        // animate the compass-rose
        let compassRoseAnimation = CABasicAnimation()
        compassRoseAnimation.autoreverses   = true
        compassRoseAnimation.duration       = rotationDurationForDegrees(45.0, withRate: kRateOfRotation)
        compassRoseAnimation.fromValue      = NSNumber(value: 0.0 as Double)
        compassRoseAnimation.keyPath        = "transform.rotation.z"
        compassRoseAnimation.repeatDuration = 30.0
        compassRoseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        compassRoseAnimation.toValue        = NSNumber(value: (45.0).radians as Double)
        compassRoseAnimation.delegate       = self
        compassLayer.add(compassRoseAnimation, forKey: "rotateAnimation")
        
        // animate the ADF1 needle
        let adf1Animation = CABasicAnimation()
        adf1Animation.autoreverses      = true
        adf1Animation.duration          = rotationDurationForDegrees(320.0, withRate: kRateOfRotation)
        adf1Animation.fromValue         = NSNumber(value: 0.0 as Double)
        adf1Animation.keyPath           = "transform.rotation.z"
        adf1Animation.repeatDuration    = 30.0
        adf1Animation.timingFunction    = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        adf1Animation.toValue           = NSNumber(value: (-320).radians as Double)
        adf1Layer.add(adf1Animation, forKey:"rotateAnimation")
        
        // animate the ADF2 needle
        let adf2Animation = CABasicAnimation()
        adf2Animation.autoreverses      = true
        adf2Animation.duration          = rotationDurationForDegrees(270.0, withRate: kRateOfRotation)
        adf2Animation.fromValue         = NSNumber(value: 0.0 as Double)
        adf2Animation.keyPath           = "transform.rotation.z"
        adf2Animation.repeatDuration    = 30.0
        adf2Animation.timingFunction    = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        adf2Animation.toValue           = NSNumber(value: (270).radians as Double)
        adf2Layer.add(adf2Animation, forKey:"rotateAnimation")
        
        // animate the heading triangle
        let headingAnimation = CABasicAnimation()
        headingAnimation.autoreverses   = true
        headingAnimation.duration       = rotationDurationForDegrees(98.0, withRate: kRateOfRotation)
        headingAnimation.fromValue      = NSNumber(value: 0.0 as Double)
        headingAnimation.keyPath        = "transform.rotation.z"
        headingAnimation.repeatDuration = 30.0
        headingAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        headingAnimation.toValue        = NSNumber(value: (-98).radians as Double)
        autopilotHeadingLayer.add(headingAnimation, forKey:"rotateAnimation")
        
        // animate the VOR1 needle
        let vor1Animation = CABasicAnimation()
        vor1Animation.autoreverses      = true
        vor1Animation.duration          = rotationDurationForDegrees(180.0, withRate: kRateOfRotation)
        vor1Animation.fromValue         = NSNumber(value: 0.0 as Double)
        vor1Animation.keyPath           = "transform.rotation.z"
        vor1Animation.repeatDuration    = 30.0
        vor1Animation.timingFunction    = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        vor1Animation.toValue           = NSNumber(value: (-180).radians as Double)
        vor1Layer.add(vor1Animation, forKey:"rotateAnimation")
        
        // animate the VOR2 needle
        let vor2Animation = CABasicAnimation()
        vor2Animation.autoreverses      = true
        vor2Animation.duration          = rotationDurationForDegrees(180.0, withRate: kRateOfRotation)
        vor2Animation.fromValue         = NSNumber(value: 0.0 as Double)
        vor2Animation.keyPath           = "transform.rotation.z"
        vor2Animation.repeatDuration    = 30.0
        vor2Animation.timingFunction    = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        vor2Animation.toValue           = NSNumber(value: (180).radians as Double)
        vor2Layer.add(vor2Animation, forKey:"rotateAnimation")
        
        // animate the NAV course needle
        let navAnimation = CABasicAnimation()
        navAnimation.autoreverses       = true
        navAnimation.duration           = rotationDurationForDegrees(45.0, withRate: kRateOfRotation)
        navAnimation.fromValue          = NSNumber(value: 0.0 as Double)
        navAnimation.keyPath            = "transform.rotation.z"
        navAnimation.repeatDuration     = 30.0
        navAnimation.timingFunction     = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        navAnimation.toValue            = NSNumber(value: (45.0).radians as Double)
        navLayer.add(navAnimation, forKey:"rotateAnimation")
    }
    
    // MARK: - Private Methods
    fileprivate func rotationDurationForDegrees(_ degrees: CGFloat, withRate rate: CGFloat) -> CFTimeInterval {
        if degrees > Angle.min.degrees && rate > 0 {
            return CFTimeInterval(degrees / rate)
        } else {
            return 0.0
        }
    }
}

// MARK: - CAAnimationn Delegate Methods
extension NDView: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        bitInProgress = false
        
        self.ADF1Enabled = false
        self.ADF2Enabled = false
        self.autopilotHeadingEnabled = false
        self.radioNAVSource = .off
        self.VOR1Enabled = false
        self.VOR2Enabled = false
        
        bitCompletion?(flag)
    }
}
