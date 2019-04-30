//
//  AutopilotHeadingLayer.swift
//  AirbusNavDisplay
//
//  Layer displaying the autopilot heading bug for Airbus Nav Display
//
//  Created by Michael A. Crawford on 12/13/15.
//  Copyright © 2015 Crawford Design Engineering, LLC. All rights reserved.
//

import UIKit

class AutopilotHeadingLayer: NDLayer {

    private let kAutopilotBugHeightMultiplier: CGFloat = 0.115
    
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
        ctx.setLineWidth(2.0)
        ctx.setStrokeColor(UIColor.blue.cgColor)

        // Center and rotate the drawing context so that 0,0 is at the center and
        // zero degrees is at the top of the context.
        ctx.translateBy(x: self.bounds.midX, y: self.bounds.midY)
        ctx.rotate(by: CGFloat(-90.0.radians))
        
        // Draw heading triangle outside of the compas-rose
        self.drawTriangleAtPoint(
            CGPoint(x: self.radius + 2.0, y: 0.0),
            inContext: ctx,
            withAngle: 0.0,
            andRadius: self.radius * kAutopilotBugHeightMultiplier,
            usingDrawingMode: .stroke)
        
        ctx.restoreGState()
    }
}
