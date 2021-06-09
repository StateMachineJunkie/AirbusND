//
//  VOR2Layer.swift
//  AirbusNavDisplay
//
//  Layer displaying the second VOR needle for Airbus Nav Display
//
//  Created by Michael A. Crawford on 12/13/15.
//  Copyright © 2015 Crawford Design Engineering, LLC. All rights reserved.
//

import UIKit

class VOR2Layer: NDLayer {

    let kFirstSegmentPointMultiplier: CGFloat = 0.7915
    let kSecondSegmentPointMultiplier: CGFloat = 0.7085
    
    // MARK: - Initializer
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer as AnyObject)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Drawing
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        ctx.withLocalGState {
            // set drawing properties
            ctx.setLineWidth(1.0)
            ctx.setStrokeColor(UIColor.white.cgColor)
            
            // Center and rotate the drawing context so that 0,0 is at the center and
            // zero degrees is at the top of the context.
            ctx.translateBy(x: self.bounds.midX, y: self.bounds.midY)
            ctx.rotate(by: CGFloat(-90.0.radians))
            
            // Compute radius based values used for drawing
            let firstSegmentPoint = self.radius * kFirstSegmentPointMultiplier
            let fiveDegreeSegmentWidth: CGFloat = self.circumference / 36.0 / 2.0
            let halfRadius: CGFloat = self.radius * 0.5
            let secondSegmentPoint = self.radius * kSecondSegmentPointMultiplier
            let twoPointFiveDegreeSegmentWidth: CGFloat = self.circumference / 36.0 / 4.0
            
            // Draw VOR needle
            ctx.beginPath()
            
            // center/forward segment
            ctx.move(to: CGPoint(x: self.radius, y: 0.0))
            ctx.addLine(to: CGPoint(x: firstSegmentPoint, y: 0.0))
            
            // top/forward segment
            ctx.move(to: CGPoint(x: secondSegmentPoint, y: twoPointFiveDegreeSegmentWidth))
            ctx.addLine(to: CGPoint(x: halfRadius, y: twoPointFiveDegreeSegmentWidth))
            
            // bottom/forward segment
            ctx.move(to: CGPoint(x: secondSegmentPoint, y: -twoPointFiveDegreeSegmentWidth))
            ctx.addLine(to: CGPoint(x: halfRadius, y: -twoPointFiveDegreeSegmentWidth))
            
            // top/forward arrow-head segment
            ctx.move(to: CGPoint(x: firstSegmentPoint, y: 0.0))
            ctx.addLine(to: CGPoint(x: secondSegmentPoint, y: fiveDegreeSegmentWidth))
            ctx.addLine(to: CGPoint(x: secondSegmentPoint, y: twoPointFiveDegreeSegmentWidth))
            
            // bottom/forward arrow-head segment
            ctx.move(to: CGPoint(x: firstSegmentPoint, y: 0.0))
            ctx.addLine(to: CGPoint(x: secondSegmentPoint, y: -fiveDegreeSegmentWidth))
            ctx.addLine(to: CGPoint(x: secondSegmentPoint, y: -twoPointFiveDegreeSegmentWidth))
            
            // top/aft segment
            ctx.move(to: CGPoint(x: -halfRadius, y: twoPointFiveDegreeSegmentWidth))
            ctx.addLine(to: CGPoint(x: -secondSegmentPoint, y: twoPointFiveDegreeSegmentWidth))
            
            // bottom/aft segment
            ctx.move(to: CGPoint(x: -halfRadius, y: -twoPointFiveDegreeSegmentWidth))
            ctx.addLine(to: CGPoint(x: -secondSegmentPoint, y: -twoPointFiveDegreeSegmentWidth))
            
            // connect tails of previous two segments to form a closed aft segment
            ctx.addLine(to: CGPoint(x: -secondSegmentPoint, y: twoPointFiveDegreeSegmentWidth))
            
            // center/aft segment
            ctx.move(to: CGPoint(x: -self.radius, y: 0.0))
            ctx.addLine(to: CGPoint(x: -secondSegmentPoint, y: 0.0))
            
            ctx.drawPath(using: .stroke)
        }
    }
}
