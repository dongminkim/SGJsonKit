//
//  SGJsonArray.h
//
//  http://github.com/dongminkim/SGJsonKit
//

#import <Foundation/Foundation.h>
#import "SGJsonObject.h"

@interface SGJsonArray : SGJsonObject <NSFastEnumeration>

+ (Class)classForArrayItem;

// NSArray methods
- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfObject:(id)anObject;

// NSMutableArray methods
- (void)addObject:(id)anObject;
- (void)removeObjectsInRange:(NSRange)aRange;
- (void)removeObject:(id)anObject;
- (void)removeAllObjects;

// Objective-C Literal methods
- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;

@end
