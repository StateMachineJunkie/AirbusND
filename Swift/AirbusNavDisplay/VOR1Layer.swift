//
//  VOR1Layer.swift
//  AirbusNavDisplay
//
//  Layer displaying the first VOR needle for Airbus Nav Display
//
//  Created by Michael A. Crawford on 12/13/15.
//  Copyright © 2015 Crawford Design Engineering, LLC. All rights reserved.
//

import UIKit

class VOR1Layer: NDLayer {

    let kFirstSegmentPointMultiplier: CGFloat = 0.916
    let kSecondSegmentPointMultiplier: CGFloat = 0.833
    
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
            
            // Draw VOR needle
            ctx.beginPath()
            
            // center/forward segment #1
            ctx.move(to: CGPoint(x: self.radius, y: 0.0))
            ctx.addLine(to: CGPoint(x: firstSegmentPoint, y: 0.0))
            
            // center/forward segment #2
            ctx.move(to: CGPoint(x: secondSegmentPoint, y: 0.0))
            ctx.addLine(to: CGPoint(x: halfRadius, y: 0.0))
            
            // center/aft segment #1
            ctx.move(to: CGPoint(x: -halfRadius, y: 0.0))
            ctx.addLine(to: CGPoint(x: -secondSegmentPoint, y: 0.0))
            
            // center/aft segment #2
            ctx.move(to: CGPoint(x: -firstSegmentPoint, y: 0.0))
            ctx.addLine(to: CGPoint(x: -self.radius, y: 0.0))
            
            // top/forward arrow-head segment
            ctx.move(to: CGPoint(x: firstSegmentPoint, y: 0.0))
            ctx.addLine(to: CGPoint(x: secondSegmentPoint, y: fiveDegreeSegmentWidth))
            
            // bottom/forward arrow-head segment
            ctx.move(to: CGPoint(x: firstSegmentPoint, y: 0.0))
            ctx.addLine(to: CGPoint(x: secondSegmentPoint, y: -fiveDegreeSegmentWidth))
            
            // connect tails of previous two segments to form a triangle
            ctx.addLine(to: CGPoint(x: secondSegmentPoint, y: fiveDegreeSegmentWidth))
            
            // top/aft arrow-head segment
            ctx.move(to: CGPoint(x: -secondSegmentPoint, y: 0.0))
            ctx.addLine(to: CGPoint(x: -firstSegmentPoint, y: fiveDegreeSegmentWidth))
            
            // bottom/aft arrow-head segment
            ctx.move(to: CGPoint(x: -secondSegmentPoint, y: 0.0))
            ctx.addLine(to: CGPoint(x: -firstSegmentPoint, y: -fiveDegreeSegmentWidth))
            
            // connect tails of previous two segments to for a second triangle
            ctx.addLine(to: CGPoint(x: -firstSegmentPoint, y: fiveDegreeSegmentWidth))
            
            ctx.drawPath(using: .stroke)
        }
    }
}
