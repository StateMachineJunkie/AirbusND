//
//  CGContextExtension.swift
//  AirbusNavDisplay
//
//  Created by Michael A. Crawford on 5/28/19.
//  Copyright © 2019 Crawford Design Engineering, LLC. All rights reserved.
//

import CoreGraphics

extension CGContext {

    func withLocalGState(_ draw: () -> ()) {
        saveGState()
        draw()
        restoreGState()
    }
}
