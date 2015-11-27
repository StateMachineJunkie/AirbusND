//
//  NDInfoLayer.h
//  AirbusND
//
//  Created by Michael A. Crawford on 12/30/08.
//  Copyright 2008 Crawford Design Engineering, Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@protocol DrawInfoString

- (void)drawInfoString;

@end


@interface NDInfoLayer : CATextLayer <DrawInfoString>

@property (nonatomic, retain) NSFont* labelFont;
@property (nonatomic) CGFloat previousTextSize;
@property (nonatomic) CGFloat radius;
@property (nonatomic, readonly) CGFloat textSize;
@property (nonatomic) NSFont* valueFont;

- (id)initWithFrame:(NSRect)frame;

@end
