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

- (NSString *)description
{
    return [NSObject describeArrayItems:self];
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

- (NSUInteger)indexOfObject:(id)anObject
{
    return [self.array indexOfObject:anObject];
}


#pragma mark - NSMutableArray

- (void)addObject:(id)anObject
{
    Class itemClass = [[self class] classForArrayItem];
    if (![anObject isKindOfClass:itemClass]) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"%@ addObject: param is %@ NOT %@.", self, [anObject class], itemClass];
    }
    [self.array addObject:anObject];
}

- (void)removeObjectsInRange:(NSRange)aRange
{
    [self.array removeObjectsInRange:aRange];
}

- (void)removeObject:(id)anObject
{
    [self.array removeObject:anObject];
}

- (void)removeAllObjects
{
    [self.array removeAllObjects];
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
