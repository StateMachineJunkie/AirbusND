//
//  NavAid.h
//  AirbusND
//
//  The NavAid class represents a real-world nav-aid, which can be either an ILS,
//  NDB, or VOR.
//
//  Created by Michael A. Crawford on 12/5/08.
//  Copyright 2008 Crawford Design Engineering, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
    MCADFNavAidType = 0,
    MCILSNavAidType = 1,
    MCVORNavAidType = 2
} MCNavAidType;

typedef struct _MCPosition {
    CGFloat latitude;
    CGFloat longitude;
} MCPosition;

typedef MCPosition* MCPositionPointer;
typedef MCPosition* MCPositionArray;

NS_INLINE MCPosition MCMakePosition(CGFloat latitude, CGFloat longitude) {
    MCPosition p;
    p.latitude = latitude;
    p.longitude = longitude;
    return p;
}

typedef struct _MCNavAid {
    CGFloat         course; // ILS only
    CGFloat         frequency;
    MCPosition      position;
    MCNavAidType    type;
} MCNavAid;

typedef MCNavAid* MCNavAidPointer;
typedef MCNavAid* MCNavAidArray;

NS_INLINE MCNavAid MCMakeNavAid(CGFloat frequency,
                                CGFloat latitude,
                                CGFloat longitude,
                                MCNavAidType type) {
    MCNavAid n;
    n.course = -1;
    n.frequency = frequency;
    n.position.latitude = latitude;
    n.position.longitude = longitude;
    n.type = type;
    return n;
}

NS_INLINE MCNavAid MCMakeILS(CGFloat course,
                             CGFloat frequency,
                             CGFloat latitude,
                             CGFloat longitude) {
    MCNavAid n;
    n.course = course;
    n.frequency = frequency;
    n.position.latitude = latitude;
    n.position.longitude = longitude;
    n.type = MCILSNavAidType;
    return n;
}
