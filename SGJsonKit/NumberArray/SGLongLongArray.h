//
//  SGLongLongArray.h
//
//  http://github.com/dongminkim/SGJsonKit
//

#import <Foundation/Foundation.h>
#import "SGNumberArray.h"

@interface SGLongLongArray : NSObject <SGNumberArray, NSCopying>

@property (nonatomic, readonly) long long *values;
@property (nonatomic, readonly) NSUInteger count;

- (instancetype)initWithValues:(long long *)values count:(NSUInteger)count;

@end

