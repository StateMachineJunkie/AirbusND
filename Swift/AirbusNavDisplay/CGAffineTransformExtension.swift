//
//  CGAffineTransformExtension.swift
//  AirbusNavDisplay
//
//  Created by Michael A. Crawford on 12/24/15.
//  Copyright © 2015 Crawford Design Engineering, LLC. All rights reserved.
//

import UIKit

public extension CGAffineTransform {
    
    var rotationAngle: CGFloat { return atan2(b, a) } // radians
    var scaleX: CGFloat { get { return a } }
    var scaleY: CGFloat { get { return d } }
    
    init(fullTransform: CATransform3D) {
        self.init(a: fullTransform.m11,
                  b: fullTransform.m12,
                  c: fullTransform.m21,
                  d: fullTransform.m22,
                  tx: fullTransform.m41,
                  ty: fullTransform.m42)
        // m13, m23, m33, m43 are not important since the destination is a flat XY plane.
        // m31, m32 are not important since they would multiply with z = 0.
        // m34 is zeroed here, so that neutralizes foreshortening. We can't avoid that.
        // m44 is implicitly 1 as CGAffineTransform's m33.
    }
}
