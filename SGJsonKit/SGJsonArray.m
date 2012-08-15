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
@property (nonatomic, strong) NSMutableArray *array;
@end


@implementation SGJsonArray
@synthesize array=array_;

+ (Class)classForArrayItem
{
    NSAssert(NO, @"This is an abstract method that should be overridden in a subclass.");
    return nil;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.array = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithJSONObject:(id)jsonObject
{
    NSArray *arr = (NSArray*)jsonObject;
    if (arr == nil) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"%@ addObject: param is %@ NOT %@.", self, [jsonObject class], [NSArray class]];
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

- (id)JSONObject
{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:[self.array count]];
    for (id value_ in self.array) {
        id value = value_;
        if ([value conformsToProtocol:@protocol(SGJson)]) {
            value = [value JSONObject];
        }
        [arr addObject:value];
    }
    return arr;
}

- (NSString *)description
{
    NSMutableString *propertyDescriptions = [[NSMutableString alloc] initWithFormat:@"%@[\n", [self class]];
    for (id value_ in self.array) {
        id value = value_;
        [propertyDescriptions appendFormat:@"\t%@,\n", value];
    }
    [propertyDescriptions appendFormat:@"]"];
    return propertyDescriptions;
}


#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    SGJsonArray *copy = [[[self class] allocWithZone:zone] init];
    copy.array = self.array;
    return copy;
}


#pragma mark - NSArray
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.array;
}

- (BOOL)isKindOfClass:(Class)aClass
{
    if ([[self class] isSubclassOfClass:aClass])
        return YES;
    return [self.array isKindOfClass:aClass];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [self.array countByEnumeratingWithState:state objects:buffer count:len];
}

- (NSUInteger)count
{
    return [self.array count];
}

- (id)objectAtIndex:(NSUInteger)index
{
    return [self.array objectAtIndex:index];
}

- (void)addObject:(id)anObject
{
    Class itemClass = [[self class] classForArrayItem];
    if (![anObject isKindOfClass:itemClass]) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"%@ addObject: param is %@ NOT %@.", self, [anObject class], itemClass];
    }
    [self.array addObject:anObject];
}

@end
