//
//  SGIntArray.m
//
//  http://github.com/dongminkim/SGJsonKit
//

#import "SGIntArray.h"

@interface SGIntArray ()
@property (nonatomic) NSData *data;
@end


@implementation SGIntArray

- (instancetype)initWithValues:(int *)values count:(NSUInteger)count
{
    self = [super init];
    if (self != nil) {
        self.data = [NSData dataWithBytes:(const void *)values length:(count * sizeof(int))];
        _values = (int *)self.data.bytes;
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
            int value = number.intValue;
            [data appendBytes:(const void *)&value length:sizeof(int)];
        }
        self.data = data;
        _values = (int *)self.data.bytes;
        _count = array.count;
    }
    return self;
}

- (NSNumber *)numberAtIndex:(NSUInteger)idx
{
    return [NSNumber numberWithInt:_values[idx]];
}

- (NSArray *)numberArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:_count];
    for (NSUInteger i=0; i < _count; i++) {
        [array addObject:[NSNumber numberWithInt:_values[i]]];
    }
    return array;
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[SGIntArray allocWithZone:zone] initWithValues:self.values count:self.count];
    return copy;
}

@end
