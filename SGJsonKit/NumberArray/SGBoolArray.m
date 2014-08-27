//
//  SGBoolArray.m
//
//  http://github.com/dongminkim/SGJsonKit
//

#import "SGBoolArray.h"

@interface SGBoolArray ()
@property (nonatomic) NSData *data;
@end


@implementation SGBoolArray

- (instancetype)initWithValues:(BOOL *)values count:(NSUInteger)count
{
    self = [super init];
    if (self != nil) {
        self.data = [NSData dataWithBytes:(const void *)values length:(count * sizeof(BOOL))];
        _values = (BOOL *)self.data.bytes;
        _count = count;
    }
    return self;
}

- (instancetype)initWithNumberArray:(NSArray *)array
{
    self = [super init];
    if (self != nil) {
        NSMutableData *data = [NSMutableData data];
        for (NSNumber *number in array) {
            BOOL value = number.boolValue;
            [data appendBytes:(const void *)&value length:sizeof(BOOL)];
        }
        self.data = data;
        _values = (BOOL *)self.data.bytes;
        _count = array.count;
    }
    return self;
}

- (NSArray *)numberArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:_count];
    for (NSUInteger i=0; i < _count; i++) {
        [array addObject:[NSNumber numberWithBool:_values[i]]];
    }
    return array;
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[SGBoolArray allocWithZone:zone] initWithValues:self.values count:self.count];
    return copy;
}

@end
