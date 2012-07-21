//
//  SGJsonArray.m
//  SGJsonKit
//
//  Created by 김 동민 on 7/21/12.
//  Copyright (c) 2012 TheVanity.org. All rights reserved.

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "SGJsonKit.h"

@interface SGJsonArray ()
@property (nonatomic, strong) NSArray *array;
@end


@implementation SGJsonArray
@synthesize array=array_;

- (id)initWithJSONObject:(id)jsonObject
{
    NSArray *arr = (NSArray*)jsonObject;
    if (arr == nil) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"%@ initWithJSONObject: NOT with NSArray.", self];
    }
    
    self = [super init];
    if (self != nil) {
        NSMutableArray *values = [[NSMutableArray alloc] init];
        if (arr != nil && [arr count] > 0)
        {
            Class itemClass = [[self class] classForArrayItem];
            for (id value_ in arr)
            {
                id value = value_;
                if ([itemClass conformsToProtocol:@protocol(SGJson)]) {
                    value = [[itemClass alloc] initWithJSONObject:value];
                }
                [values addObject:value];
            }
        }
        self.array = values;
    }
    return self;
}

+ (Class)classForArrayItem
{
    NSAssert(NO, @"This is an abstract method that should be overridden in a subclass.");
    return nil;
}

#pragma mark -
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.array;
}

- (BOOL)isKindOfClass:(Class)aClass
{
    return [self.array isKindOfClass:aClass];
}

@end
