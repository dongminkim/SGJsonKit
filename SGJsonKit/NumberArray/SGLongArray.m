//
//  SGLongArray.m
//
//  http://github.com/dongminkim/SGJsonKit
//

#import "SGLongArray.h"

@interface SGLongArray ()
@property (nonatomic) NSData *data;
@end


@implementation SGLongArray

- (instancetype)initWithValues:(long *)values count:(NSUInteger)count
{
    self = [super init];
    if (self != nil) {
        self.data = [NSData dataWithBytes:(const void *)values length:(count * sizeof(long))];
        _values = (long *)self.data.bytes;
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
            long value = number.longValue;
            [data appendBytes:(const void *)&value length:sizeof(long)];
        }
        self.data = data;
        _values = (long *)self.data.bytes;
        _count = array.count;
    }
    return self;
}

- (NSNumber *)numberAtIndex:(NSUInteger)idx
{
    return [NSNumber numberWithLong:_values[idx]];
}

- (NSArray *)numberArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:_count];
    for (NSUInteger i=0; i < _count; i++) {
        [array addObject:[NSNumber numberWithLong:_values[i]]];
    }
    return array;
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[SGLongArray allocWithZone:zone] initWithValues:self.values count:self.count];
    return copy;
}

@end
