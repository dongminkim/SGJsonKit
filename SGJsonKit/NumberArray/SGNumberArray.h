//
//  SGNumberArray.h
//
//  http://github.com/dongminkim/SGJsonKit
//

@protocol SGNumberArray
@required

//- (instancetype)initWithValues:(void *)values count:(NSUInteger)count;
- (instancetype)initWithNumberArray:(NSArray *)array;

//- (void *)values;
- (NSUInteger)count;

- (NSArray *)numberArray;

@end
