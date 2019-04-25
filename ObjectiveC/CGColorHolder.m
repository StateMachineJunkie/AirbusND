//
//  CGColorHolder.m
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

#import "CGColorHolder.h"

@interface CGColorHolder(Private)

+ (CGColorRef)allocColorWithRed:(CGFloat)red
                     green:(CGFloat)green
                      blue:(CGFloat)blue
                     alpha:(CGFloat)alpha;

@end

@implementation CGColorHolder

+ (CGColorRef)black
{
    static CGColorRef color = NULL;
    if ( NULL == color )
    {
        color = [self allocColorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
    }
    return color;
}

+ (CGColorRef)blue
{
    static CGColorRef color = NULL;
    if ( NULL == color )
    {
        color = [self allocColorWithRed:0.0f green:0.0f blue:1.0f alpha:1.0f];
    }
    return color;
}

+ (CGColorRef)brown
{
    static CGColorRef color = NULL;
    if ( NULL == color )
    {
        color = [self allocColorWithRed:0.6f green:0.4f blue:0.2f alpha:1.0f];
    }
    return color;
}

+ (CGColorRef)clear
{
    static CGColorRef color = NULL;
    if ( NULL == color )
    {
        color = [self allocColorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    }
    return color;
}

+ (CGColorRef)cyan
{
    static CGColorRef color = NULL;
    if ( NULL == color )
    {
        color = [self allocColorWithRed:0.0f green:1.0f blue:1.0f alpha:1.0f];
    }
    return color;
}

+ (CGColorRef)darkGray
{
    static CGColorRef color = NULL;
    if ( NULL == color )
    {
        color = [self allocColorWithRed:0.333f green:0.333f blue:0.333f alpha:1.0f];
    }
    return color;
}

+ (CGColorSpaceRef)genericRGBSpace
{
    static CGColorSpaceRef colorSpace = NULL;
    if ( NULL == colorSpace )
    {
        colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    }
    return colorSpace;
}

+ (CGColorRef)gray
{
    static CGColorRef color = NULL;
    if ( NULL == color )
    {
        color = [self allocColorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
    }
    return color;
}

+ (CGColorRef)green
{
    static CGColorRef color = NULL;
    if ( NULL == color )
    {
        color = [self allocColorWithRed:0.0f green:1.0f blue:0.0f alpha:1.0f];
    }
    return color;
}

+ (CGColorRef)halfRed
{
    static CGColorRef color = NULL;
    if ( NULL == color )
    {
        color = [self allocColorWithRed:1.0f green:0.0f blue:0.0f alpha:0.5f];
    }
    return color;
}  
+ (CGColorRef)halfBlue
{
    static CGColorRef color = NULL;
    if ( NULL == color )
    {
        color = [self allocColorWithRed:0.0f green:0.0f blue:1.0f alpha:0.5f];
    }
    return color;
}

+ (CGColorRef)halfWhite
{
    static CGColorRef color = NULL;
    if ( NULL == color )
    {
        color = [self allocColorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
    }
    return color;
}

+ (CGColorRef)lightGray
{
    static CGColorRef color = NULL;
    if ( NULL == color )
    {
        color = [self allocColorWithRed:0.667f green:0.667f blue:0.667f alpha:1.0f];
    }
    return color;
}


+ (CGColorRef)magenta
{
    static CGColorRef color = NULL;
    if ( NULL == color )
    {
        color = [self allocColorWithRed:1.0f green:0.0f blue:1.0f alpha:1.0f];
    }
    return color;
}

+ (CGColorRef)orange
{
    static CGColorRef color = NULL;
    if ( NULL == color )
    {
        color = [self allocColorWithRed:1.0f green:0.5f blue:0.0f alpha:1.0f];
    }
    return color;
}

+ (CGColorRef)red
{
    static CGColorRef color = NULL;
    if ( NULL == color )
    {
        color = [self allocColorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f];
    }
    return color;
}

+ (CGColorRef)purple
{
    static CGColorRef color = NULL;
    if ( NULL == color )
    {
        color = [self allocColorWithRed:0.5f green:0.0f blue:0.5f alpha:1.0f];
    }
    return color;
}

+ (CGColorRef)white
{
    static CGColorRef color = NULL;
    if ( NULL == color )
    {
        color = [self allocColorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    }
    return color;
}

+ (CGColorRef)yellow
{
    static CGColorRef color = NULL;
    if ( NULL == color )
    {
        color = [self allocColorWithRed:1.0f green:1.0f blue:0.0f alpha:1.0f];
    }
    return color;
}

@end

@implementation CGColorHolder(Private)

+ (CGColorRef)allocColorWithRed:(CGFloat)red
                     green:(CGFloat)green
                      blue:(CGFloat)blue
                     alpha:(CGFloat)alpha
{
    CGFloat values[4] = { red, green, blue, alpha };
    return CGColorCreate([self genericRGBSpace], values);
}

@end

