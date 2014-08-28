//
//  SGNumberArray.m
//
//  http://github.com/dongminkim/SGJsonKit
//

#import "SGNumberArray.h"

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
    NSMutableString *propertyDescriptions = [[NSMutableString alloc] initWithFormat:@"%@[", [self class]];
    for (NSNumber *number in self.numberArray) {
        [propertyDescriptions appendFormat:@"%@, ", number.stringValue];
    }
    [propertyDescriptions deleteCharactersInRange:NSMakeRange(propertyDescriptions.length - 2, 2)];
    [propertyDescriptions appendFormat:@"]"];
    return propertyDescriptions;
}

@end