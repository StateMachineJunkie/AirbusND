//
//  Observer.m
//  AirbusND
//
//  Created by Michael A. Crawford on 4/28/09.
//  Copyright 2009 Crawford Software Design & Engineering. All rights reserved.
//

#import "Observer.h"


@implementation Observer

@synthesize target, action;

- (id)initWithTarget:(id)aTarget action:(SEL)anAction
{
    self = [super init];
    
    if ( self )
    {
        target = aTarget;
        action = anAction;
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
    [target performSelector:action withObject:[object valueForKeyPath:keyPath]]; 
}

- (void)dealloc
{
    target = nil;
    action = nil;
}

@end
