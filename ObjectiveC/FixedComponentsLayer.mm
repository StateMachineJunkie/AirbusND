//
//  FixedComponentsLayer.m
//  AirbusND
//
//  Created by Michael A. Crawford on 11/15/08.
//  Copyright 2008 Crawford Design Engineering, Inc. All rights reserved.
//

#import "FixedComponentsLayer.h"
#import "CGColorHolder.h"
#import "NDUtilities.h"

//
// The glide-slope-deviation ratio is calculated based on the proportion of the
// radius of the Navigation Display used for placing the glide-scale-circles and
// the number of degrees represented for each glide-scale-circle.  The circles
// are placed at 1/3 increments from the center of the display and each circle
// represents 0.35 degrees of glide-slope deviation.  Thus:
//
//      0.33 / 0.35 = 0.942857
//
float const kGlideSlopeDeviationRatio = 0.942857;

static NSString* const fixedComponentsFont = @"verdana";

@implementation FixedComponentsLayer

#pragma mark - Properties

@synthesize glideSlopeDeviation     = _glideSlopeDeviation;
@synthesize glideSlopeEnabled       = _glideSlopeEnabled;
@synthesize navAid1TextLayer        = _navAid1TextLayer;
@synthesize navAid2TextLayer        = _navAid2TextLayer;
@synthesize range                   = _range;
@synthesize speedInfoTextLayer      = _speedInfoTextLayer;
@synthesize waypointInfoTextLayer   = _waypointInfoTextLayer;

#pragma mark - Initialization Methods

- (id)init
{
    self = [super init];
    
    if ( self )
    {
        self.name = @"fixedComponents";
        
        // initialize default state info
        _glideSlopeDeviation = 0.0;
        _glideSlopeEnabled = FALSE;
        _range = 10;
    }
    
    return self;
}

- (NSString*)description
{
    return @"Airbus Navigation Display Fixed-Components layer";
}

- (void)awakeFromNib
{
    NSLog(@"%@: awakeFromNib", self);
    
//    CGContextRef ctx = CGContextRef([[NSGraphicsContext currentContext] graphicsPort]);
//    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    
    // create text layers for each text element on the fixed-components layer
    _navAid1TextLayer       = [CATextLayer layer];
    _navAid2TextLayer       = [CATextLayer layer];
    _speedInfoTextLayer     = [CATextLayer layer];
    _waypointInfoTextLayer  = [CATextLayer layer];
    
    [self addSublayer:self.speedInfoTextLayer];
    [self addSublayer:self.waypointInfoTextLayer];
    [self addSublayer:self.navAid1TextLayer];
    [self addSublayer:self.navAid2TextLayer];

    // create string used for speed-info display
    NSFont* font = [NSFont fontWithName:@"verdana" size:11.0];
    
    NSMutableAttributedString* s =
        [[NSMutableAttributedString alloc] initWithString:@"GS 200 TAS 210"];
    
    [s addAttribute:NSFontAttributeName
               value:font
               range:NSMakeRange(0, 13)];
    
    [s addAttribute:NSForegroundColorAttributeName
               value:(NSColor*)[CGColorHolder white]
               range:NSMakeRange(0, 1)];
    
    [s addAttribute:NSForegroundColorAttributeName
               value:(NSColor*)[CGColorHolder green]
               range:NSMakeRange(3, 5)];
    
//    [s addAttribute:NSForegroundColorAttributeName
//               value:(NSColor*)[CGColorHolder white]
//               range:NSMakeRange(7, 9)];
    
//    [s addAttribute:NSForegroundColorAttributeName
//              value:(NSColor*)[CGColorHolder green]
//               range:NSMakeRange(11, 13)];

    // initialize nav-aid 1 info layer
    _navAid1TextLayer.font              = CFBridgingRetain(fixedComponentsFont);
    _navAid1TextLayer.fontSize          = 14.0;
    _navAid1TextLayer.foregroundColor   = [CGColorHolder green];
    _navAid1TextLayer.name              = @"navAid1Info";
    _navAid1TextLayer.position          = CGPointMake(0.0, 0.0);
    _navAid1TextLayer.string            = @"TBD";
    
    // initialize nav-aid 2 info layer
    _navAid2TextLayer.font              = CFBridgingRetain(fixedComponentsFont);
    _navAid2TextLayer.fontSize          = 10.0;
    _navAid2TextLayer.foregroundColor   = [CGColorHolder green];
    _navAid2TextLayer.name              = @"navAid2Info";
    _navAid2TextLayer.position          = CGPointMake(50.0, 50.0);
    _navAid2TextLayer.string            = @"TBD";
    
    // initialize speed-info layer
    _speedInfoTextLayer.font            = CFBridgingRetain(fixedComponentsFont);
    _speedInfoTextLayer.fontSize        = 10.0;
    _speedInfoTextLayer.foregroundColor = [CGColorHolder white];
    _speedInfoTextLayer.name            = @"speedInfo";
    _speedInfoTextLayer.position        = CGPointMake(10.0, 10.0);
    _speedInfoTextLayer.string          = @"TBD";
    
    // initialize waypoint-info layer
    _waypointInfoTextLayer.font             = CFBridgingRetain(fixedComponentsFont);
    _waypointInfoTextLayer.fontSize         = 10.0;
    _waypointInfoTextLayer.foregroundColor  = [CGColorHolder white];
    _waypointInfoTextLayer.name             = @"waypointInfo";
    _waypointInfoTextLayer.position         = CGPointMake(50.0, 10.0);
    _waypointInfoTextLayer.string           = @"TBD";

    // give all sub-layers the same size, position, mask, etc.
	for ( CATextLayer* subLayer in self.sublayers )
	{
        //		subLayer.bounds = CGRectMake(0.0f,
        //                                     0.0f,
        //                                     CGRectGetWidth(self.bounds),
        //                                     CGRectGetHeight(self.bounds));
        subLayer.bounds = self.bounds;
		subLayer.opacity = 1.0f;
		[subLayer setNeedsDisplay];
		subLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
		subLayer.needsDisplayOnBoundsChange = YES;
	}
}

#pragma mark - Public Methods

- (void)setGlideSlopeDeviation:(CGFloat)newDeviation
{
    _glideSlopeDeviation = newDeviation;
    [self setNeedsDisplay];
}

- (void)setGlideSlopeEnabled:(BOOL)isEnabled
{
    _glideSlopeEnabled = isEnabled;
    [self setNeedsDisplay];
}

- (void)setGroundSpeed:(float)value
{
    // TBD
}

- (void)setNavAid1Info:(NavAid*)info
{
    // TBD
}

- (void)setNavAid2Info:(NavAid*)info
{
    // TBD
}

- (void)setRange:(int)newRange
{
    _range = newRange;
    [self setNeedsDisplay];
}

- (void)setTrueAirSpeed:(float)value
{
    // TBD
}

- (void)setWaypointInfo:(Waypoint*)info
{
    // TBD
}

- (void)setWindDirection:(float)value
{
    // TBD
}

- (void)setWindSpeed:(float)value
{
    // TBD
}

#pragma mark -
#pragma mark Drawing Methods

- (void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
    
	CGContextSaveGState(ctx);
    
    // set drawing properties
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetStrokeColorWithColor(ctx, [CGColorHolder yellow]);
    
	// center the drawing context
	CGContextTranslateCTM(ctx, CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // draw little plane in center of compass-rose
    CGContextMoveToPoint(ctx, 0.0, self.radius * 0.10);
    CGContextAddLineToPoint(ctx, 0.0, -(self.radius * 0.20));
    CGContextMoveToPoint(ctx, -(self.radius * 0.15), 0.0);
    CGContextAddLineToPoint(ctx, (self.radius * 0.15), 0.0);
    CGContextMoveToPoint(ctx, -(self.radius * 0.05), -(self.radius * 0.15));
    CGContextAddLineToPoint(ctx, (self.radius * 0.05), -(self.radius * 0.15));
    
    // draw nose indicator
    CGContextMoveToPoint(ctx, 0.0, self.radius * 1.12);
    CGContextAddLineToPoint(ctx, 0.0, self.radius * 0.95);
    
	// commit drawing
	CGContextDrawPath(ctx, kCGPathStroke);
	
    // draw solid triangles at 45 degree increments around the compass-rose
    CGContextSetFillColorWithColor(ctx, [CGColorHolder white]);
    
    // we need to orient the drawing context so that 0 degrees is straigh up
    CGContextRotateCTM(ctx, DegreesToRadians(90.0));
    
    // draw solid triangles at 45 degree increments around the compass-rose
    for ( CGFloat i = 45.0; i < 360.0; i += 45.0 )
	{
		CGPoint point = PointOnCircumference(i, self.radius);
        [self drawTriangleAtPoint:point
                        inContext:ctx
                        withAngle:i
                        andLength:self.radius * 0.07
                 usingDrawingMode:kCGPathFill];
    }
    
	// set text drawing properties; draw 'range' text
	CGContextSetFillColorWithColor(ctx, [CGColorHolder cyan]);
	CGContextSetStrokeColorWithColor(ctx, [CGColorHolder cyan]);
	CGContextSelectFont(ctx, "Verdana", self.textSize - 2, kCGEncodingMacRoman);

    //
    // In order to draw text correctly it must be rotated and justified
    // according to is position on the ND.
    //
    CGContextRotateCTM(ctx, DegreesToRadians(-90));
    
    CGPoint point = PointOnCircumference(223.0, self.radius);
    NSString* s = [NSString stringWithFormat:@"%d", self.range];
    char const* p = [s UTF8String];
    CGContextShowTextAtPoint(ctx, point.x + 1.0, point.y + 1.0, p, strlen(p));

    point = PointOnCircumference(223.0, self.radius / 2.0);
    s = [NSString stringWithFormat:@"%d", self.range / 2];
    p = [s UTF8String];
    CGContextShowTextAtPoint(ctx, point.x + 1.0, point.y + 1.0, p, strlen(p));
    
    //
    // If NAV is in ILS mode, draw glide-slope deviation (GSD) scale
    //
    if ( self.glideSlopeEnabled )
    {
        float gsdOffsetX    = self.bounds.size.width * 0.45;
        float gsdMarkRadius = self.radius * 0.025;
        
        CGContextBeginPath(ctx);
        CGContextSetStrokeColorWithColor(ctx, [CGColorHolder white]);
        
        CGContextMoveToPoint(ctx, gsdOffsetX + gsdMarkRadius, self.radius * 0.66);
        CGContextAddArc(ctx, gsdOffsetX, self.radius * 0.66, gsdMarkRadius, 0.0, DegreesToRadians(360.0), 0);    

        CGContextMoveToPoint(ctx, gsdOffsetX + gsdMarkRadius, self.radius * 0.33);
        CGContextAddArc(ctx, gsdOffsetX, self.radius * 0.33, gsdMarkRadius, 0.0, DegreesToRadians(360.0), 0);    

        CGContextMoveToPoint(ctx, gsdOffsetX + gsdMarkRadius, self.radius * -0.33);
        CGContextAddArc(ctx, gsdOffsetX, self.radius * -0.33, gsdMarkRadius, 0.0, DegreesToRadians(360.0), 0);    
        
        CGContextMoveToPoint(ctx, gsdOffsetX + gsdMarkRadius, self.radius * -0.66);
        CGContextAddArc(ctx, gsdOffsetX, self.radius * -0.66, gsdMarkRadius, 0.0, DegreesToRadians(360.0), 0);    

        CGContextDrawPath(ctx, kCGPathStroke);

        CGContextBeginPath(ctx);
        CGContextSetStrokeColorWithColor(ctx, [CGColorHolder yellow]);
        CGContextSetLineWidth(ctx, 2.0);
        
        CGContextMoveToPoint(ctx, gsdOffsetX + (gsdMarkRadius * 2.0), 0.0);
        CGContextAddLineToPoint(ctx, gsdOffsetX - (gsdMarkRadius * 2.0), 0.0);
        
        CGContextDrawPath(ctx, kCGPathStroke);
        
        CGContextSetStrokeColorWithColor(ctx, [CGColorHolder magenta]);
        
        float gsdOffsetY;
                    
        if ( self.glideSlopeDeviation > 0.70 )
        {
            self.glideSlopeDeviation = 0.70;
            gsdOffsetY = self.radius * self.glideSlopeDeviation * kGlideSlopeDeviationRatio;
         
            
            // draw up-carret
            [self drawCarretAtPoint:CGPointMake(gsdOffsetX - (gsdMarkRadius * 2.0), gsdOffsetY)
                          inContext:ctx
                         withLength:gsdMarkRadius * 2.0
                   andUpOrientation:YES];
        }
        else if ( self.glideSlopeDeviation < -0.70 )
        {
            self.glideSlopeDeviation = -0.70;
            gsdOffsetY = self.radius * self.glideSlopeDeviation * kGlideSlopeDeviationRatio;
            
            
            // draw down-carret
            [self drawCarretAtPoint:CGPointMake(gsdOffsetX - (gsdMarkRadius * 2.0), gsdOffsetY)
                          inContext:ctx
                         withLength:gsdMarkRadius * 2.0
                   andUpOrientation:NO];
        }
        else
        {
            gsdOffsetY = self.radius * self.glideSlopeDeviation * kGlideSlopeDeviationRatio;
            
            [self drawRhombusAtPoint:CGPointMake(gsdOffsetX - (gsdMarkRadius * 2.0), gsdOffsetY)
                           inContext:ctx withAngle:0.0
                           andLength:gsdMarkRadius * 2.0
                    usingDrawingMode:kCGPathStroke];
        }
    }

	CGContextRestoreGState(ctx);
}

@end
