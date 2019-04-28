//
//  ADF2Layer.swift
//  AirbusNavDisplay
//
//  Layer displaying the second automatic direction finder meedle for Airbus Nav Display
//
//  Created by Michael A. Crawford on 12/13/15.
//  Copyright © 2015 Crawford Design Engineering, LLC. All rights reserved.
//

import UIKit

class ADF2Layer: NDLayer {

    let kFirstSegmentPointMultiplier: CGFloat = 0.677
    let kSecondSegmentPointMultiplier: CGFloat = 0.584
    
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
        
        ctx.saveGState()
        
        // set drawing properties
        ctx.setLineWidth(1.0)
        ctx.setStrokeColor(UIColor.green.cgColor)

        // Center and rotate the drawing context so that 0,0 is at the center and
        // zero degrees is at the top of the context.
        ctx.translateBy(x: self.bounds.midX, y: self.bounds.midY)
        ctx.rotate(by: CGFloat(-90.0.radians))
        
        // Compute radius based values used for drawing
        let fiveDegreeSegmentWidth: CGFloat = self.circumference / 36.0 / 2.0
        let halfRadius: CGFloat = self.radius * 0.5
        let threeQuarterRadius: CGFloat = self.radius * 0.75
        let firstSegmentPoint = self.radius * kFirstSegmentPointMultiplier
        let secondSegmentPoint = self.radius * kSecondSegmentPointMultiplier

        // Draw ADF1 needle
        ctx.beginPath()
        
        // top/forward segment
        ctx.move(to: CGPoint(x: secondSegmentPoint, y: fiveDegreeSegmentWidth))
        ctx.addLine(to: CGPoint(x: halfRadius, y: fiveDegreeSegmentWidth))
        
        // top/aft segment
        ctx.move(to: CGPoint(x: -threeQuarterRadius, y: fiveDegreeSegmentWidth))
        ctx.addLine(to: CGPoint(x: -halfRadius, y: fiveDegreeSegmentWidth))
        
        // botton/forward segment
        ctx.move(to: CGPoint(x: secondSegmentPoint, y: -fiveDegreeSegmentWidth))
        ctx.addLine(to: CGPoint(x: halfRadius, y: -fiveDegreeSegmentWidth));
        
        // bottom/aft segment
        ctx.move(to: CGPoint(x: -threeQuarterRadius, y: -fiveDegreeSegmentWidth));
        ctx.addLine(to: CGPoint(x: -halfRadius, y: -fiveDegreeSegmentWidth));
        
        // center/forward segment
        ctx.move(to: CGPoint(x: self.radius, y: 0.0));
        ctx.addLine(to: CGPoint(x: firstSegmentPoint, y: 0.0));
        
        // center/aft segment
        ctx.move(to: CGPoint(x: -self.radius, y: 0.0));
        ctx.addLine(to: CGPoint(x: -firstSegmentPoint, y: 0.0));
        
        // connector center/forward to top/forward
        ctx.move(to: CGPoint(x: firstSegmentPoint, y: 0.0));
        ctx.addLine(to: CGPoint(x: secondSegmentPoint, y: fiveDegreeSegmentWidth));
        
        // connector center/forward to bottom/forward
        ctx.move(to: CGPoint(x: firstSegmentPoint, y: 0.0));
        ctx.addLine(to: CGPoint(x: secondSegmentPoint, y: -fiveDegreeSegmentWidth));
        
        
        // connector center/aft to top/aft
        ctx.move(to: CGPoint(x: -firstSegmentPoint, y: 0.0));
        ctx.addLine(to: CGPoint(x: -threeQuarterRadius, y: fiveDegreeSegmentWidth));
        
        // connector center/aft to bottom/aft
        ctx.move(to: CGPoint(x: -firstSegmentPoint, y: 0.0));
        ctx.addLine(to: CGPoint(x: -threeQuarterRadius, y: -fiveDegreeSegmentWidth));
        
        ctx.drawPath(using: .stroke)
        
        ctx.restoreGState()
    }
}
