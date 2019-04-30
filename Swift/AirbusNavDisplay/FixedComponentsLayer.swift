//
//  FixedComponentsLayer.swift
//  AirbusNavDisplay
//
//  Created by Michael A. Crawford on 12/16/15.
//  Copyright © 2015 Crawford Design Engineering, LLC. All rights reserved.
//

import UIKit

//
// The glide-slope-deviation ratio is calculated based on the proportion of the
// radius of the Navigation Display used for placing the glide-scale-circles and
// the number of degrees represented for each glide-scale-circle.  The circles
// are placed at 1/3 increments from the center of the display and each circle
// represents 0.35 degrees of glide-slope deviation.  Thus:
//
//      0.33 / 0.35 = 0.942857
//

class FixedComponentsLayer: NDLayer {

    private let kGlideSlopeDeviationRatio: CGFloat = 0.942857;
    
    var glideSlopeDeviation: CGFloat = Angle.min.degrees {
        didSet {
            if glideSlopeDeviation != oldValue {
                self.setNeedsDisplay()
            }
        }
    }
    
    var glideSlopeEnabled: Bool = false {
        didSet {
            if glideSlopeEnabled != oldValue {
                self.setNeedsDisplay()
            }
        }
    }
    
    var range: Int = 10 {
        didSet {
            if range != oldValue {
                self.setNeedsDisplay()
            }
        }
    }
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        ctx.saveGState();

        // Center drawing context
        ctx.translateBy(x: self.bounds.midX, y: self.bounds.midY)
        
        // We need to orient the drawing context so that 0 degrees is straigh up
        ctx.rotate(by: CGFloat(90.0).radians)
        
        // Draw solid triangles at 45 degree increments around the compass-rose
        ctx.setFillColor(UIColor.white.cgColor)
        
        for angle in stride(from: -135.0, to: 180.0, by: 45.0) {
            let point = pointOnCircumferenceWithAngle(CGFloat(angle), radius: self.radius)
            drawTriangleAtPoint(point,
                inContext: ctx,
                withAngle: CGFloat(angle),
                andRadius: self.radius * 0.07,
                usingDrawingMode: .fill)
        }
        
        // Set text drawing properties; draw 'range' text
        ctx.setFillColor(UIColor.cyan.cgColor)
        ctx.setStrokeColor(UIColor.cyan.cgColor)
        let font = CTFontCreateWithName("Verdana" as CFString, self.textSize, nil)
        let attributes: [NSAttributedString.Key : AnyObject] = [
            .font : font,
            kCTForegroundColorFromContextAttributeName as NSAttributedString.Key : true as AnyObject
        ]
        
        // In order to draw text correctly it must be rotated and justified
        // according to is position on the ND. Additionally the Y coordinates
        // need to be flipped
        ctx.rotate(by: CGFloat(-90).radians);
        ctx.scaleBy(x: 1.0, y: -1.0) // flip Y coordinates
        
        var point = pointOnCircumferenceWithAngle(223.0, radius: self.radius)
        var s = NSAttributedString(string: String(self.range), attributes: attributes)
        var line = CTLineCreateWithAttributedString(s)
        ctx.textPosition = CGPoint(x: point.x + 1.0, y: point.y + 1.0)
        CTLineDraw(line, ctx)
        
        point = pointOnCircumferenceWithAngle(223.0, radius: self.radius / 2.0)
        s = NSAttributedString(string: String(self.range / 2), attributes: attributes)
        line = CTLineCreateWithAttributedString(s)
        ctx.textPosition = CGPoint(x: point.x + 1.0, y: point.y + 1.0)
        CTLineDraw(line, ctx)

        ctx.scaleBy(x: 1.0, y: -1.0) // restore Y coordinates
        
        // If NAV is in ILS mode, draw glide-slope deviation (GSD) scale
        if ( self.glideSlopeEnabled ) {
            let gsdOffsetX: CGFloat = self.bounds.size.width * 0.45
            let gsdMarkRadius: CGFloat = self.radius * 0.025
            
            ctx.beginPath()
            ctx.setStrokeColor(UIColor.white.cgColor);
            
            // Draw scale marker 2/3 above glide-slope
            ctx.move(to: CGPoint(x: gsdOffsetX + gsdMarkRadius, y: self.radius * 0.67))
            ctx.addArc(center: CGPoint(x: gsdOffsetX, y: self.radius * 0.66),
                       radius: gsdMarkRadius,
                       startAngle: CGFloat(0.0),
                       endAngle: CGFloat(360.0).radians,
                       clockwise: false)
            
            // Draw scale marker 1/3 above glide-slope
            ctx.move(to: CGPoint(x: gsdOffsetX + gsdMarkRadius, y: self.radius * 0.33))
            ctx.addArc(center: CGPoint(x: gsdOffsetX, y: self.radius * 0.33),
                       radius: gsdMarkRadius,
                       startAngle: CGFloat(0.0),
                       endAngle: CGFloat(360.0).radians,
                       clockwise: false)
            
            // Draw scale marker 1/3 below glide-slope
            ctx.move(to: CGPoint(x: gsdOffsetX + gsdMarkRadius, y: self.radius * -0.33))
            ctx.addArc(center: CGPoint(x: gsdOffsetX, y: self.radius * -0.33),
                       radius: gsdMarkRadius,
                       startAngle: CGFloat(0.0),
                       endAngle: CGFloat(360.0).radians,
                       clockwise: false)
            
            // Draw scale marker 2/3 below glide-slope
            ctx.move(to: CGPoint(x: gsdOffsetX + gsdMarkRadius, y: self.radius * -0.67))
            ctx.addArc(center: CGPoint(x: gsdOffsetX, y: self.radius * -0.66),
                       radius: gsdMarkRadius,
                       startAngle: CGFloat(0.0),
                       endAngle: CGFloat(360.0).radians,
                       clockwise: false)
            
            ctx.drawPath(using: .stroke)
            
            // Draw center glide-slope marker
            ctx.beginPath()
            ctx.setStrokeColor(UIColor.yellow.cgColor)
            ctx.setLineWidth(2.0)
            
            ctx.move(to: CGPoint(x: gsdOffsetX + (gsdMarkRadius * 2.0), y: 0.0))
            ctx.addLine(to: CGPoint(x: gsdOffsetX - (gsdMarkRadius * 2.0), y: 0.0))
            
            ctx.drawPath(using: .stroke)
            
            // Draw glide-slope deviation rhombus / carret (half rhombus)
            ctx.setStrokeColor(UIColor.magenta.cgColor)
            
            var gsdOffsetY: CGFloat = 0;
            
            if ( self.glideSlopeDeviation > 0.70 ) {
                self.glideSlopeDeviation = 0.70
                gsdOffsetY = self.radius * self.glideSlopeDeviation * kGlideSlopeDeviationRatio
                
                
                // draw up-carret
                self.drawCarretAtPoint(CGPoint(x: gsdOffsetX + (2.0) - (gsdMarkRadius * 2.0), y: gsdOffsetY),
                    inContext: ctx,
                    withRadius: gsdMarkRadius * 2.0,
                    andUpOrientation: true)
            } else if ( self.glideSlopeDeviation < -0.70 ) {
                self.glideSlopeDeviation = -0.70;
                gsdOffsetY = self.radius * self.glideSlopeDeviation * kGlideSlopeDeviationRatio;
                
                
                // draw down-carret
                self.drawCarretAtPoint(CGPoint(x: gsdOffsetX + (2.0) - (gsdMarkRadius * 2.0), y: gsdOffsetY),
                    inContext: ctx,
                    withRadius: gsdMarkRadius * 2.0,
                    andUpOrientation: false)
            } else {
                gsdOffsetY = self.radius * self.glideSlopeDeviation * kGlideSlopeDeviationRatio;
                
                self.drawRhombusAtPoint(CGPoint(x: gsdOffsetX + (2.0) - (gsdMarkRadius * 2.0), y: gsdOffsetY),
                    inContext: ctx,
                    withAngle: 0.0,
                    andRadius: gsdMarkRadius * 2.0,
                    usingDrawingMode: .stroke)
            }
        }
        
        ctx.restoreGState();
    }
}
