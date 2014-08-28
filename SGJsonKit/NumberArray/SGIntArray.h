//
//  SGIntArray.h
//
//  http://github.com/dongminkim/SGJsonKit
//

#import <Foundation/Foundation.h>
#import "SGNumberArray.h"

@interface SGIntArray : SGNumberArray

@property (nonatomic, readonly) int *values;
@property (nonatomic, readonly) NSUInteger count;

- (instancetype)initWithValues:(int *)values count:(NSUInteger)count;

@end

