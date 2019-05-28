//
//  NavLayer.swift
//  AirbusNavDisplay
//
//  Created by Michael A. Crawford on 12/16/15.
//  Copyright © 2015 Crawford Design Engineering, LLC. All rights reserved.
//

import UIKit

//
// The lateral and localizer deviation ratios are calculated based on the
// proportion of the radius of the Navigation Display used for placing the
// deviation-scale-circles and the number of degrees represented for each
// deviation-scale-circle.  The circles are placed at 1/4 increments from the
// center of the display and each circle represents 5.0 degrees and 1.25 degrees
// of deviation, respectively. Thus:
//
//      0.25 / 5.0  = 0.05
//      0.25 / 1.25 = 0.2
//

class NavLayer: NDLayer {

    private let kFirstSegmentPointMultiplier: CGFloat = 0.667
    private let kLateralDeviationRatio: CGFloat = 0.05
    private let kLocalizerDeviationRatio: CGFloat = 0.2
    private let kSecondSegmentPointMultiplier: CGFloat = 0.417
    
    private let vorCourseDeviationRange: ClosedRange<CGFloat> = -10.0...10.0
    private let ilsCourseDeviationRange: ClosedRange<CGFloat> = -2.5...2.5
    
    var courseDeviation: CGFloat = Angle.min.degrees {
        didSet {
            if courseDeviation != oldValue {
                self.setNeedsDisplay()
            }
        }
    }
    
    var drawILS: Bool = false {
        didSet {
            if drawILS != oldValue {
                self.setNeedsDisplay()
            }
        }
    }
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        ctx.withLocalGState {
            // Set drawing properties
            ctx.setLineWidth(1.0)
            
            if drawILS {
                ctx.setStrokeColor(UIColor.magenta.cgColor)
            } else {
                ctx.setStrokeColor(UIColor.cyan.cgColor)
            }
            
            // Center and rotate drawing context so that 0,0 is at the center and
            // zero degrees is at the top of the context
            ctx.translateBy(x: self.bounds.midX, y: self.bounds.midY)
            ctx.rotate(by: CGFloat(-90.0).radians)
            
            // Compute radius based values used for drawing
            let halfRadius: CGFloat = self.radius * 0.5
            let firstSegmentPoint = self.radius * kFirstSegmentPointMultiplier
            let quarterRadius: CGFloat = halfRadius * 0.5
            let width = self.circumference / 36.0
            let halfWidth = width * 0.5
            let secondSegmentPoint = self.radius * kSecondSegmentPointMultiplier
            let tinyRadius = self.radius * 0.025
            
            // Draw NAV course needle. The arrow-heads of this needle have a width
            // that is the same as the width of the ADF2 needle.
            ctx.beginPath()
            
            // Center/forward segment
            ctx.move(to: CGPoint(x: self.radius, y: 0.0))
            ctx.addLine(to: CGPoint(x: halfRadius, y: 0.0))
            
            // Center/aft segment
            ctx.move(to: CGPoint(x: -self.radius, y: 0.0))
            ctx.addLine(to: CGPoint(x: -halfRadius, y: 0.0))
            
            // Cross segment
            ctx.move(to: CGPoint(x: firstSegmentPoint, y: halfWidth))
            ctx.addLine(to: CGPoint(x: firstSegmentPoint, y: -halfWidth))
            
            // Draw VOR or ILS course deviation bar (center segment) depending on
            // drawILS setting.
            var deviationOffsetY: CGFloat
            var courseDeviation = self.courseDeviation
            
            if drawILS { // draw ILS
                if courseDeviation > ilsCourseDeviationRange.upperBound {
                    courseDeviation = ilsCourseDeviationRange.upperBound
                } else if courseDeviation < ilsCourseDeviationRange.lowerBound {
                    courseDeviation = ilsCourseDeviationRange.lowerBound
                }
                deviationOffsetY = self.radius * courseDeviation * kLocalizerDeviationRatio
            } else {    // draw VOR
                if courseDeviation > vorCourseDeviationRange.upperBound {
                    courseDeviation = vorCourseDeviationRange.upperBound
                } else if courseDeviation < vorCourseDeviationRange.lowerBound {
                    courseDeviation = vorCourseDeviationRange.lowerBound
                }
                deviationOffsetY = self.radius * courseDeviation * kLateralDeviationRatio
                
                // Top/forward arrow-head segment
                ctx.move(to: CGPoint(x: halfRadius, y: deviationOffsetY))
                ctx.addLine(to: CGPoint(x: secondSegmentPoint, y: halfWidth + deviationOffsetY))
                
                // Bottom/forward arrow-head segment
                ctx.move(to: CGPoint(x: halfRadius, y: deviationOffsetY))
                ctx.addLine(to: CGPoint(x: secondSegmentPoint, y: -halfWidth + deviationOffsetY))
            }
            
            ctx.move(to: CGPoint(x: halfRadius, y: deviationOffsetY))
            ctx.addLine(to: CGPoint(x: -halfRadius, y: deviationOffsetY))
            
            // Commit drawing
            ctx.drawPath(using: .stroke)
            
            // Draw VOR/ILS course deviation scale
            ctx.beginPath()
            
            ctx.setStrokeColor(UIColor.white.cgColor)
            
            ctx.move(to: CGPoint(x: tinyRadius, y: halfRadius))
            ctx.addArc(center: CGPoint(x: 0.0, y: halfRadius),
                       radius: tinyRadius,
                       startAngle: 0.0,
                       endAngle: CGFloat(360.0).radians,
                       clockwise: false)
            
            ctx.move(to: CGPoint(x: tinyRadius, y: quarterRadius))
            ctx.addArc(center: CGPoint(x: 0.0, y: quarterRadius),
                       radius: tinyRadius,
                       startAngle: 0.0,
                       endAngle: CGFloat(360).radians,
                       clockwise: false)
            
            ctx.move(to: CGPoint(x: tinyRadius, y: -halfRadius))
            ctx.addArc(center: CGPoint(x: 0.0, y: -halfRadius),
                       radius: tinyRadius,
                       startAngle: 0.0,
                       endAngle: CGFloat(360.0),
                       clockwise: false)
            
            ctx.move(to: CGPoint(x: tinyRadius, y: -quarterRadius))
            ctx.addArc(center: CGPoint(x: 0.0, y: -quarterRadius),
                       radius: tinyRadius,
                       startAngle: 0.0,
                       endAngle: CGFloat(360.0).radians,
                       clockwise: (false))
            
            ctx.drawPath(using: .stroke)

        }
    }
}
