//
//  SGJsonArray.h
//
//  http://github.com/dongminkim/SGJsonKit
//

#import <Foundation/Foundation.h>
#import "SGJsonObject.h"

@interface SGJsonArray : SGJsonObject <NSFastEnumeration>

+ (Class)classForArrayItem;

- (instancetype)initWithArray:(NSArray *)array;
- (NSArray *)array;

// KVC
- (id)valueForKey:(NSString *)key;
- (id)valueForKeyPath:(NSString *)keyPath;
- (void)setValue:(id)value forKey:(NSString *)key;
- (void)setValue:(id)value forKeyPath:(NSString *)keyPath;

// NSArray methods
- (BOOL)containsObject:(id)anObject;
- (NSUInteger)count;
- (void)getObjects:(id __unsafe_unretained [])objects range:(NSRange)range;
- (id)firstObject;
- (id)lastObject;
- (id)objectAtIndex:(NSUInteger)index;
- (NSArray *)objectsAtIndexes:(NSIndexSet *)indexes;
- (NSUInteger)indexOfObject:(id)anObject;
- (NSUInteger)indexOfObject:(id)anObject inRange:(NSRange)range;
- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject;
- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject inRange:(NSRange)range;

// NSMutableArray methods
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)addObject:(id)anObject;
- (void)removeAllObjects;
- (void)removeLastObject;
- (void)removeObject:(id)anObject;
- (void)removeObject:(id)anObject inRange:(NSRange)range;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)removeObjectIdenticalTo:(id)anObject inRange:(NSRange)range;
- (void)removeObjectIdenticalTo:(id)anObject;
- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes;
- (void)removeObjectsInArray:(NSArray *)otherArray;
- (void)removeObjectsInRange:(NSRange)range;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

// Objective-C Literal methods
- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;

// NSArray enumerate methods
- (void)enumerateObjectsAtIndexes:(NSIndexSet *)indexSet options:(NSEnumerationOptions)opts usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;

@end
