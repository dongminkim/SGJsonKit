//
//  SGBoolArray.h
//
//  http://github.com/dongminkim/SGJsonKit
//

#import <Foundation/Foundation.h>
#import "SGNumberArray.h"

@interface SGBoolArray : NSObject <SGNumberArray, NSCopying>

@property (nonatomic, readonly) BOOL *values;
@property (nonatomic, readonly) NSUInteger count;

- (instancetype)initWithValues:(BOOL *)values count:(NSUInteger)count;

@end

