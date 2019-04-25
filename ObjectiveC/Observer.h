//
//  Observer.h
//  AirbusND
//
//  Created by Michael A. Crawford on 4/28/09.
//  Copyright 2009 Crawford Software Design & Engineering. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//
// Observer
//
// This utility class allows us to simplify situations where a single object
// needs to observe multiple objects or attributes.  Normally, to accomplish
// this, a single method (observeValueForKeyPath:ofObject:change:context:) is
// required to handle multiple callbacks for multiple objects.  The resulting
// code can quickly become unwieldy and difficult to maintain.  With this class
// the observing object can easily observe multiple objects and attributes and
// easily designate a separate handler for each.
//
@interface Observer : NSObject
{
    id  target;
    SEL action;
}
@property(readonly, retain) id target;
@property(readonly, assign) SEL action;

- (id)initWithTarget:(id)target action:(SEL)action;

@end
