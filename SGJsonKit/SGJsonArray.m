//
//  SGJsonArray.m
//
//  http://github.com/dongminkim/SGJsonKit
//

#import "SGJsonKit.h"
#import "NSObject+SGJsonKit.h"

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

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.array = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithJSONObject:(id)jsonObject
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
                } else if ([itemClass conformsToProtocol:@protocol(SGNumberArray)]) {
                    value = [[itemClass alloc] initWithNumberArray:value];
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
        } else if ([value conformsToProtocol:@protocol(SGNumberArray)]) {
            value = [value numberArray];
        }
        [arr addObject:value];
    }
    return arr;
}

- (void)checkClassOfArrayItem:(id)anObject
{
    Class itemClass = [[self class] classForArrayItem];
    if (![anObject isKindOfClass:itemClass]) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"%@ addObject: param is %@ NOT %@.", self, [anObject class], itemClass];
    }
}

- (NSString *)description
{
    return [NSObject describeArrayItems:self];
}


#pragma mark - Forwarding

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


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    SGJsonArray *copy = [[[self class] allocWithZone:zone] init];
    copy.array = self.array;
    return copy;
}


#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [self.array countByEnumeratingWithState:state objects:buffer count:len];
}


#pragma mark - NSArray

- (BOOL)containsObject:(id)anObject
{
    return [self.array containsObject:anObject];
}

- (NSUInteger)count
{
    return [self.array count];
}

- (void)getObjects:(id __unsafe_unretained [])objects range:(NSRange)range
{
    [self.array getObjects:objects range:range];
}

- (id)firstObject
{
    return [self.array firstObject];
}

- (id)lastObject
{
    return [self.array lastObject];
}

- (id)objectAtIndex:(NSUInteger)index
{
    return [self.array objectAtIndex:index];
}

- (NSArray *)objectsAtIndexes:(NSIndexSet *)indexes
{
    return [self.array objectsAtIndexes:indexes];
}

- (NSUInteger)indexOfObject:(id)anObject
{
    return [self.array indexOfObject:anObject];
}

- (NSUInteger)indexOfObject:(id)anObject inRange:(NSRange)range
{
    return [self.array indexOfObject:anObject inRange:range];
}

- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject
{
    return [self.array indexOfObjectIdenticalTo:anObject];
}

- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject inRange:(NSRange)range
{
    return [self.array indexOfObjectIdenticalTo:anObject inRange:range];
}


#pragma mark - NSMutableArray

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    [self checkClassOfArrayItem:anObject];
    [self.array insertObject:anObject atIndex:index];
}

- (void)addObject:(id)anObject
{
    [self checkClassOfArrayItem:anObject];
    [self.array addObject:anObject];
}

- (void)removeAllObjects
{
    [self.array removeAllObjects];
}

- (void)removeLastObject
{
    [self.array removeLastObject];
}

- (void)removeObject:(id)anObject
{
    [self.array removeObject:anObject];
}

- (void)removeObject:(id)anObject inRange:(NSRange)range
{
    [self.array removeObject:anObject inRange:range];
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    [self.array removeObjectAtIndex:index];
}

- (void)removeObjectIdenticalTo:(id)anObject inRange:(NSRange)range
{
    [self.array removeObjectIdenticalTo:anObject inRange:range];
}

- (void)removeObjectIdenticalTo:(id)anObject
{
    [self.array removeObjectIdenticalTo:anObject];
}

- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes
{
    [self.array removeObjectsAtIndexes:indexes];
}

- (void)removeObjectsInArray:(NSArray *)otherArray
{
    [self.array removeObjectsInArray:otherArray];
}

- (void)removeObjectsInRange:(NSRange)range
{
    [self.array removeObjectsInRange:range];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    [self checkClassOfArrayItem:anObject];
    [self.array replaceObjectAtIndex:index withObject:anObject];
}


#pragma mark - Objective-C Literal

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    return [self.array objectAtIndexedSubscript:idx];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
    [self.array setObject:obj atIndexedSubscript:idx];
}


#pragma mark - NSArray enumerate methods

- (void)enumerateObjectsAtIndexes:(NSIndexSet *)indexSet options:(NSEnumerationOptions)opts usingBlock:(void (^)(id, NSUInteger, BOOL *))block
{
    [self.array enumerateObjectsAtIndexes:indexSet options:opts usingBlock:block];
}

- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id, NSUInteger, BOOL *))block
{
    [self.array enumerateObjectsWithOptions:opts usingBlock:block];
}

- (void)enumerateObjectsUsingBlock:(void (^)(id, NSUInteger, BOOL *))block
{
    [self.array enumerateObjectsUsingBlock:block];
}

@end
