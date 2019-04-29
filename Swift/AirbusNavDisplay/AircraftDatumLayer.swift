//
//  AircraftDatumLayer.swift
//  AirbusNavDisplay
//
//  Created by Michael A. Crawford on 12/16/15.
//  Copyright © 2015 Crawford Design Engineering, LLC. All rights reserved.
//

import UIKit

class AircraftDatumLayer: NDLayer {

    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        ctx.saveGState();

        // Set drawing properties
        ctx.setLineWidth(2.0)
        ctx.setStrokeColor(UIColor.yellow.cgColor)
        
        // Center drawing context
        ctx.translateBy(x: self.bounds.midX, y: self.bounds.midY)
        
        // Draw little plane in the center of compass-rose
        ctx.move(to: CGPoint(x: 0.0, y: -self.radius * 0.10))
        ctx.addLine(to: CGPoint(x: 0.0, y: (self.radius * 0.20)))
        ctx.move(to: CGPoint(x: (self.radius * 0.15), y: 0.0))
        ctx.addLine(to: CGPoint(x: -(self.radius * 0.15), y: 0.0))
        ctx.move(to: CGPoint(x: (self.radius * 0.05), y: (self.radius * 0.15)))
        ctx.addLine(to: CGPoint(x: -(self.radius * 0.05), y: (self.radius * 0.15)))
        
        // Draw nose indicator
        ctx.move(to: CGPoint(x: 0.0, y: -self.radius * 1.05))
        ctx.addLine(to: CGPoint(x: 0.0, y: -self.radius * 0.95))
        
        // Commit drawing
        ctx.drawPath(using: .stroke)        
        
        ctx.restoreGState();
    }
}
