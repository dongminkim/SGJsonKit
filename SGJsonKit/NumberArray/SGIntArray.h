//
//  SGIntArray.h
//
//  http://github.com/dongminkim/SGJsonKit
//

#import <Foundation/Foundation.h>
#import "SGNumberArray.h"

@interface SGIntArray : NSObject <SGNumberArray, NSCopying>

@property (nonatomic, readonly) int *values;
@property (nonatomic, readonly) NSUInteger count;

- (instancetype)initWithValues:(int *)values count:(NSUInteger)count;

@end

