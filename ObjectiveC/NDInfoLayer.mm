//
//  NDInfoLayer.mm
//  AirbusND
//
//  Created by Michael A. Crawford on 12/30/08.
//  Copyright 2008 Crawford Design Engineering, Inc. All rights reserved.
//

#import "NDInfoLayer.h"

static NSString* fontName = @"Verdana";

@implementation NDInfoLayer

#pragma mark - Properties

@synthesize labelFont = _labelFont;
@synthesize valueFont = _valueFont;

#pragma mark - Initialization Methods

- (id)initWithFrame:(NSRect)frame
{
    self = [super init];
    
    if ( self )
    {
        //
        // This is a custom initialization method we use because we want to size
        // the text based on the size of the frame.  We also need the initial
        // text size to be calculated and stored along with the previous so that
        // we know when it is time to allocate a new font (with a different point
        // size and re-draw the text for this info-layer.
        //
        _radius = (MIN(frame.size.width * 0.9, frame.size.height * 0.9) * 0.7) / 2.0;
        previousTextSize = self.textSize;
        
        //
        // Allocate fonts used for ND text info layers
        //
        _labelFont = [NSFont fontWithName:fontName size:previousTextSize * 0.846153846];
        _valueFont = [NSFont fontWithName:fontName size:previousTextSize];
    }
    
    return self;
}

#pragma mark - NSObject Overrides

- (NSString*)description
{
    return @"Airbus Navigation Display Info (text) layer";
}

#pragma mark - Public Methods

@synthesize previousTextSize;

- (CGFloat)textSize
{
    return ( self.radius * 0.10 );
}

#pragma mark - Drawing Methods

- (void)drawInContext:(CGContextRef)ctx
{
    CGFloat oldRadius = self.radius;
    self.radius = (MIN(self.superlayer.frame.size.width * 0.9, self.superlayer.frame.size.height * 0.9) * 0.7) / 2.0;
    
    if ( (self.radius != oldRadius) && (previousTextSize != self.textSize) )
    {
#if 0
        NSLog(@"%@: textSize = %f, previousTextSize = %f",
              self,
              self.textSize,
              self.previousTextSize);
        
        NSLog(@"%@:\n"
              "     string : %@\n"
              "anchorPoint : %f, %f\n"
              "     bounds : %f, %f, %f, %f\n"
              "      frame : %f, %f, %f, %f\n"
              "   position : %f, %f\n",
              self,
              [self.string string],
              self.anchorPoint.x,
              self.anchorPoint.y,
              self.bounds.origin.x,
              self.bounds.origin.y,
              self.bounds.size.width,
              self.bounds.size.height,
              self.frame.origin.x,
              self.frame.origin.y,
              self.frame.size.width,
              self.frame.size.height,
              self.position.x,
              self.position.y);
#endif
        self.previousTextSize = self.textSize;
        
        // set new text here
        
        [self drawInfoString];
    }
}

- (void)drawInfoString
{
    NSAssert(NO, @"This method should never be invoked; should be implemented in a derived class.");
}

@end
