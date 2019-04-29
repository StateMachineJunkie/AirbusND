//
//  NDCompassLayer.swift
//  AirbusNavDisplay
//
//  Layer displaying the Airbus Nav Display compass rose.
//
//  Created by Michael A. Crawford on 11/27/15.
//  Copyright © 2015 Crawford Design Engineering, LLC. All rights reserved.
//

import UIKit

class CompassRoseLayer: NDLayer {

    let kFiveDegreeTickLengthMultiplier: CGFloat = 1.03
    
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
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.setStrokeColor(UIColor.white.cgColor)
        let font = CTFontCreateWithName("Verdana" as CFString, self.textSize, nil)
        let attributes: [NSAttributedString.Key: AnyObject] = [
            .font: font,
            kCTForegroundColorFromContextAttributeName as NSAttributedString.Key: true as AnyObject
        ]
        
        // Center and rotate the drawing context so that 0,0 is at the center and
        // zero degrees is at the top of the context.
        ctx.translateBy(x: self.bounds.midX, y: self.bounds.midY)
        ctx.rotate(by: CGFloat(-90.0.radians))

        // draw initial circle
        ctx.beginPath()
        let maxDrawAngle = Angle.maxDegrees + 1.0
		ctx.addArc(center: CGPoint(x: 0, y: 0), radius: self.radius, startAngle: Angle.min.radians, endAngle: maxDrawAngle.radians, clockwise: false)
        
        // draw ticks around circle at five degree increments
		for angle in stride(from: Angle.min.degrees, to: Angle.max.degrees, by: 5.0) {
            var point = pointOnCircumferenceWithAngle(angle, radius: self.radius)
            ctx.move(to: CGPoint(x: point.x, y: point.y))
            
            if Int(angle).isMultiple(of: 2) {
                // draw ten degree tick
                point = pointOnCircumferenceWithAngle(angle, radius: self.radius * 1.06)
                
                // draw tick value at 30 degree increments
                if Int(angle).isMultiple(of: 30) {
                    // text representing compass heading value divided by 10
                    let value: CGFloat = angle * 0.10;
                    let s = NSAttributedString(string: String(Int(value)), attributes: attributes)
                    let line = CTLineCreateWithAttributedString(s)
                    
                    ctx.saveGState()
                    
                    // Draw invisibly first, in order to measure text output so that
                    // it may be adjusted to be centered on the tick.
                    ctx.setTextDrawingMode(.invisible)
					ctx.textPosition = CGPoint(x: 0, y: 0)
                    CTLineDraw(line, ctx)
                    let endingTextPosition = ctx.textPosition;
                    
                    // In order to draw text correctly it must be rotated and justified
                    // according to is position on the compass-rose. We must flip the
                    // x-coordinate system or the text is drawn in reverse.
                    ctx.rotate(by: (angle - 90).radians);
                    ctx.translateBy(x: 0.0, y: self.radius * 1.14)
                    ctx.scaleBy(x: -1.0, y: 1.0)
                    
                    // Now that we've measured the width of the text we are going
                    // to draw, we can center it over the associated tick-mark.
                    ctx.setTextDrawingMode(.fill);
					ctx.textPosition = CGPoint(x: -endingTextPosition.x * 0.5, y: -self.textSize * 0.5)
                    CTLineDraw(line, ctx)
                    
                    ctx.restoreGState()
                }
            }
            else
            {
                // draw five degree tick
                point = pointOnCircumferenceWithAngle(angle, radius: self.radius * kFiveDegreeTickLengthMultiplier)
            }
            
            ctx.addLine(to: CGPoint(x: point.x, y: point.y))
        }
        
        // commit drawing, thus far
        ctx.drawPath(using: .stroke)
        
        // draw half radius dashed-line circle
        ctx.beginPath()
        let lengths: [CGFloat] = [ 8, 6 ]
		ctx.setLineDash(phase: 0, lengths: lengths)
		ctx.addArc(center: CGPoint(x: 0, y: 0), radius: self.radius * 0.5, startAngle: Angle.min.radians, endAngle: Angle.max.radians, clockwise: false)
        
        // commit drawing
        ctx.drawPath(using: .stroke)
        
        ctx.restoreGState()
    }
}
