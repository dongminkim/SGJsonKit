//
//  SGLongLongArray.m
//
//  http://github.com/dongminkim/SGJsonKit
//

#import "SGLongLongArray.h"

@interface SGLongLongArray ()
@property (nonatomic) NSData *data;
@end


@implementation SGLongLongArray

- (instancetype)initWithValues:(long long *)values count:(NSUInteger)count
{
    self = [super init];
    if (self != nil) {
        self.data = [NSData dataWithBytes:(const void *)values length:(count * sizeof(long long))];
        _values = (long long *)self.data.bytes;
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
            long long value = number.longLongValue;
            [data appendBytes:(const void *)&value length:sizeof(long long)];
        }
        self.data = data;
        _values = (long long *)self.data.bytes;
        _count = array.count;
    }
    return self;
}

- (NSArray *)numberArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:_count];
    for (NSUInteger i=0; i < _count; i++) {
        [array addObject:[NSNumber numberWithLongLong:_values[i]]];
    }
    return array;
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[SGLongLongArray allocWithZone:zone] initWithValues:self.values count:self.count];
    return copy;
}

@end
