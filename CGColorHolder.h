//
//  CGColorHolder.h
//
//  Created by Bill Dudney on 2/27/08.
//
// Copyright 2008 Gala Factory
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Cocoa/Cocoa.h>

/*
 * Simple class that creates CGColorRef's for us and holds on to them so 
 * that we don't leak them or have to recreate them.
 */
@interface CGColorHolder : NSObject {
}

+ (CGColorRef)black;
+ (CGColorRef)blue;
+ (CGColorRef)brown;
+ (CGColorRef)clear;
+ (CGColorRef)cyan;
+ (CGColorRef)darkGray;
+ (CGColorRef)gray;
+ (CGColorRef)green;
+ (CGColorRef)lightGray;
+ (CGColorRef)magenta;
+ (CGColorRef)orange;
+ (CGColorRef)purple;
+ (CGColorRef)red;
+ (CGColorRef)white;
+ (CGColorRef)yellow;

+ (CGColorRef)halfRed;
+ (CGColorRef)halfBlue;
+ (CGColorRef)halfWhite;

@end
