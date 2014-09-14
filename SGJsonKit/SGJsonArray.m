//
//  SGJsonArray.m
//
//  http://github.com/dongminkim/SGJsonKit
//

#import "SGJsonKit.h"
#import "NSObject+SGJsonKit.h"

@interface SGJsonArray ()
@property (nonatomic, strong) NSMutableArray *realArray;
@end


@implementation SGJsonArray

+ (Class)classForArrayItem
{
    NSAssert(NO, @"This is an abstract method that should be overridden in a subclass.");
    return nil;
}

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.realArray = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithArray:(NSArray *)array
{
    self = [super init];
    if (self != nil) {
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self checkClassOfArrayItem:obj];
        }];
        self.realArray = [NSMutableArray arrayWithArray:array];
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
        self.realArray = values;
    }
    return self;
}

- (NSArray *)array
{
    return [NSArray arrayWithArray:self.realArray];
}

- (id)JSONObject
{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:[self.realArray count]];
    for (id value_ in self.realArray) {
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
    return self.realArray;
}

- (BOOL)isKindOfClass:(Class)aClass
{
    if ([[self class] isSubclassOfClass:aClass])
        return YES;
    return [self.realArray isKindOfClass:aClass];
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    SGJsonArray *copy = [[[self class] allocWithZone:zone] init];
    copy.realArray = self.realArray;
    return copy;
}


#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [self.realArray countByEnumeratingWithState:state objects:buffer count:len];
}


#pragma mark - KVC
- (id)valueForKey:(NSString *)key
{
    return [self.realArray valueForKey:key];
}

- (id)valueForKeyPath:(NSString *)keyPath
{
    return [self.realArray valueForKeyPath:keyPath];
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [self.realArray setValue:value forKey:key];
}

- (void)setValue:(id)value forKeyPath:(NSString *)keyPath
{
    [self.realArray setValue:value forKeyPath:keyPath];
}


#pragma mark - NSArray

- (BOOL)containsObject:(id)anObject
{
    return [self.realArray containsObject:anObject];
}

- (NSUInteger)count
{
    return [self.realArray count];
}

- (void)getObjects:(id __unsafe_unretained [])objects range:(NSRange)range
{
    [self.realArray getObjects:objects range:range];
}

- (id)firstObject
{
    return [self.realArray firstObject];
}

- (id)lastObject
{
    return [self.realArray lastObject];
}

- (id)objectAtIndex:(NSUInteger)index
{
    return [self.realArray objectAtIndex:index];
}

- (NSArray *)objectsAtIndexes:(NSIndexSet *)indexes
{
    return [self.realArray objectsAtIndexes:indexes];
}

- (NSUInteger)indexOfObject:(id)anObject
{
    return [self.realArray indexOfObject:anObject];
}

- (NSUInteger)indexOfObject:(id)anObject inRange:(NSRange)range
{
    return [self.realArray indexOfObject:anObject inRange:range];
}

- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject
{
    return [self.realArray indexOfObjectIdenticalTo:anObject];
}

- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject inRange:(NSRange)range
{
    return [self.realArray indexOfObjectIdenticalTo:anObject inRange:range];
}


#pragma mark - NSMutableArray

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    [self checkClassOfArrayItem:anObject];
    [self.realArray insertObject:anObject atIndex:index];
}

- (void)addObject:(id)anObject
{
    [self checkClassOfArrayItem:anObject];
    [self.realArray addObject:anObject];
}

- (void)removeAllObjects
{
    [self.realArray removeAllObjects];
}

- (void)removeLastObject
{
    [self.realArray removeLastObject];
}

- (void)removeObject:(id)anObject
{
    [self.realArray removeObject:anObject];
}

- (void)removeObject:(id)anObject inRange:(NSRange)range
{
    [self.realArray removeObject:anObject inRange:range];
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    [self.realArray removeObjectAtIndex:index];
}

- (void)removeObjectIdenticalTo:(id)anObject inRange:(NSRange)range
{
    [self.realArray removeObjectIdenticalTo:anObject inRange:range];
}

- (void)removeObjectIdenticalTo:(id)anObject
{
    [self.realArray removeObjectIdenticalTo:anObject];
}

- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes
{
    [self.realArray removeObjectsAtIndexes:indexes];
}

- (void)removeObjectsInArray:(NSArray *)otherArray
{
    [self.realArray removeObjectsInArray:otherArray];
}

- (void)removeObjectsInRange:(NSRange)range
{
    [self.realArray removeObjectsInRange:range];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    [self checkClassOfArrayItem:anObject];
    [self.realArray replaceObjectAtIndex:index withObject:anObject];
}


#pragma mark - Objective-C Literal

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    return [self.realArray objectAtIndexedSubscript:idx];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
    [self checkClassOfArrayItem:obj];
    [self.realArray setObject:obj atIndexedSubscript:idx];
}


#pragma mark - NSArray enumerate methods

- (void)enumerateObjectsAtIndexes:(NSIndexSet *)indexSet options:(NSEnumerationOptions)opts usingBlock:(void (^)(id, NSUInteger, BOOL *))block
{
    [self.realArray enumerateObjectsAtIndexes:indexSet options:opts usingBlock:block];
}

- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id, NSUInteger, BOOL *))block
{
    [self.realArray enumerateObjectsWithOptions:opts usingBlock:block];
}

- (void)enumerateObjectsUsingBlock:(void (^)(id, NSUInteger, BOOL *))block
{
    [self.realArray enumerateObjectsUsingBlock:block];
}

@end
