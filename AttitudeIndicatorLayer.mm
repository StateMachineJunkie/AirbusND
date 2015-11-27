//
//  AttitudeIndicatorLayer.mm
//  AirbusND
//
//  Created by Michael A. Crawford on 2/26/09.
//  Copyright 2009 Crawford Design Engineering, Inc.. All rights reserved.
//

#import "AttitudeIndicatorLayer.h"

@implementation AttitudeIndicatorLayer

#pragma mark - Delegate Methods

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    
    // center attitude layer
    
    // draw sky
    
    // draw earth
    
    // draw horizon & pitch-ladder
    
    CGContextRestoreGState(ctx);
}

@end
