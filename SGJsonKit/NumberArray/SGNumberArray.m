//
//  SGNumberArray.m
//
//  http://github.com/dongminkim/SGJsonKit
//

#import "SGNumberArray.h"
#import "NSObject+SGJsonKit.h"

@implementation SGNumberArray

- (instancetype)initWithNumberArray:(NSArray *)array
{
    NSAssert(NO, @"You should override the method initWithNumberArray:");
    return nil;
}

- (NSArray *)numberArray
{
    NSAssert(NO, @"You should override the method numberArray");
    return nil;
}

- (NSNumber *)numberAtIndex:(NSUInteger)idx
{
    NSAssert(NO, @"You should override the method numberAtIndex");
    return nil;
}

- (NSUInteger)count
{
    NSAssert(NO, @"You should override the method count");
    return 0;
}

- (id)copyWithZone:(NSZone *)zone
{
    NSAssert(NO, @"You should override the method copyWithZone:");
    return nil;
}

- (NSString *)description
{
    return [NSObject describeArrayItems:self];
}


#pragma mark - NSArray enumerate methods

- (void)enumerateObjectsAtIndexes:(NSIndexSet *)indexSet options:(NSEnumerationOptions)opts usingBlock:(void (^)(id, NSUInteger, BOOL *))block
{
    NSParameterAssert(block != nil);
    
    [indexSet enumerateIndexesWithOptions:opts usingBlock:^(NSUInteger idx, BOOL *stop) {
        block([self numberAtIndex:idx], idx, stop);
    }];
}

- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id, NSUInteger, BOOL *))block
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.count)];
    [self enumerateObjectsAtIndexes:indexSet options:opts usingBlock:block];
}

- (void)enumerateObjectsUsingBlock:(void (^)(id, NSUInteger, BOOL *))block
{
    [self enumerateObjectsWithOptions:0 usingBlock:block];
}

@end