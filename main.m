//
//  main.m
//  AirbusND
//
//  Created by Michael A. Crawford on 10/24/08.
//  Copyright Philips Medical Systems 2008. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DebugBreak.h"

#ifdef UNIT_TEST
#import "NDUtilities.h"
#endif

int main(int argc, char *argv[])
{
#ifdef UNIT_TEST
    for ( float i = 0; i < 360.0; ++i )
    {
        CGFloat rotation = HeadingToRotation(i);
        NSLog(@"Heading: %f -> Rotation: %f -> Heading: %f", i, rotation, RotationToHeading(rotation));
    }
#endif
	//    DebugBreak();
    return NSApplicationMain(argc,  (const char **) argv);
}
