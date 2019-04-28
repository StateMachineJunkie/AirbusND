//
//  NDLayer.swift
//  AirbusNavDisplay
//
//  Created by Michael A. Crawford on 11/27/15.
//  Copyright © 2015 Crawford Design Engineering, LLC. All rights reserved.
//

//import Darwin
import UIKit

extension FloatingPoint {
    
}

public extension Double {
    var degrees: Double { return self * 180.0 / .pi }
    var radians: Double { return self * .pi / 180.0 }
}

public extension Float {
    var degrees: Float { return self * 180.0 / .pi }
    var radians: Float { return self * .pi / 180.0 }
}

public extension CGFloat {
    var degrees: CGFloat { return CGFloat(self.native.degrees) }
    var radians: CGFloat { return CGFloat(self.native.radians) }
    
    // Any heading that is greater than 180 degrees must be converted in order for
    // the rotation to occur in the proper direction so as to be most efficient.
    // While heading values should always be positive, rotation values range from
    // negative one hundred and seventy nine (-179) to positive one hundred and
    // eighty (180).
    
    var rotationAngle: CGFloat {
        assert(self >= 0.0, "Heading values should always be positive!")
        
        if self != 0.0 && self > 180 {
            return -(360.0 - self)
        } else {
            return self
        }
    }
    
    var inverseRotationAngle: CGFloat {
        assert(self >= 0.0, "Heading values should always be positive!")
        
        if self != 0.0 {
            if self <= 180 {
                return -self
            } else {
                return 360 - self
            }
        } else {
            return self
        }
    }
    
}

//postfix operator ° {}
//postfix func ˚(degrees: Double) -> Double { return degrees.radians }

func pointOnCircumferenceWithAngle(_ angle: CGFloat, radius: CGFloat) -> CGPoint {
    return CGPoint(x: radius * cos(angle.radians), y: radius * sin(angle.radians))
}

class NDLayer: CALayer {

    // MARK: - Properties
    var circumference: CGFloat {
        return .pi * self.diameter;
    }
    
    var diameter: CGFloat {
        return min(self.bounds.size.width * 0.9, self.bounds.size.height * 0.9) * 0.75
    }
    
    var radius: CGFloat {
        return self.diameter * 0.5
    }
    
    var textSize: CGFloat {
        return self.radius * 0.10
    }
    
    // MARK: - Initializer
    override init() {
        super.init()
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        contentsScale = UIScreen.main.scale
        needsDisplayOnBoundsChange = true
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Shared Drawing Methods
    func drawCarretAtPoint(_ point: CGPoint, inContext ctx: CGContext, withRadius radius: CGFloat, andUpOrientation up: Bool ) {
        // Caller should set any drawing properties including line-width, fill-color,
        // stroke-color.  This method makes no permanent changes to the given context.
        ctx.saveGState()
        
        // Translate the drawing context for this drawing procedure
        ctx.translateBy(x: point.x, y: point.y)
        
        // Create a path to draw carret on imaginary circumference based on given radius and point
        ctx.beginPath()
        ctx.move(to: CGPoint(x: 0.0, y: 0.0))
        let vertexPoint = pointOnCircumferenceWithAngle((up ? 30.0 : -30.0), radius: radius)
        ctx.addLine(to: CGPoint(x: vertexPoint.x, y: vertexPoint.y))
        ctx.addLine(to: CGPoint(x: vertexPoint.x * 2.0, y: 0.0))
        ctx.drawPath(using: .stroke)

        ctx.restoreGState()
    }
    
    func drawRhombusAtPoint(_ point: CGPoint, inContext ctx: CGContext, withAngle angle: CGFloat, andRadius radius: CGFloat, usingDrawingMode mode: CGPathDrawingMode) {
        // Caller should set any drawing properties including line-width, fill-color,
        // stroke-color.  This method makes no permanent changes to the given context.
        ctx.saveGState()
        
        // Translate and rotate the drawing context for this drawing procedure
        ctx.translateBy(x: point.x, y: point.y)
        ctx.rotate(by: angle.radians)
        
        // Create path for rhombus on imaginary circumference based on given radius and point
        ctx.beginPath()
        ctx.move(to: CGPoint(x: 0.0, y: 0.0))
        let vertexPoint = pointOnCircumferenceWithAngle(30, radius: radius)
        ctx.addLine(to: CGPoint(x: vertexPoint.x, y: vertexPoint.y))
        ctx.addLine(to: CGPoint(x: vertexPoint.x * 2.0, y: 0.0))
        ctx.addLine(to: CGPoint(x: vertexPoint.x, y: -vertexPoint.y))
        ctx.closePath()
        ctx.drawPath(using: mode)
        
        ctx.restoreGState()
    }
    
    func drawTriangleAtPoint(_ point: CGPoint, inContext ctx: CGContext, withAngle angle: CGFloat, andRadius radius: CGFloat, usingDrawingMode mode: CGPathDrawingMode) {
        // Caller should set any drawing properties including line-width, fill-color,
        // stroke-color.  This method makes no permanent changes to the given context.
        // All triangles drawn by this routine are assumed to be equilateral.
        ctx.saveGState();
        
        // Translate and rotate the drawing context for this drawing procedure
        ctx.translateBy(x: point.x, y: point.y);
        ctx.rotate(by: angle.radians);
        
        // Create path for triangle on imaginary circumference based on given radius and point
        ctx.beginPath();
        ctx.move(to: CGPoint(x: 0.0, y: 0.0));
        let vertexPoint = pointOnCircumferenceWithAngle(30, radius: radius);
        ctx.addLine(to: CGPoint(x: vertexPoint.x, y: vertexPoint.y));
        ctx.addLine(to: CGPoint(x: vertexPoint.x, y: -vertexPoint.y));
        ctx.closePath();
        ctx.drawPath(using: mode);
        
        ctx.restoreGState();
    }
}
