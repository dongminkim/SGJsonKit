//
//  SGNumberArray.h
//
//  http://github.com/dongminkim/SGJsonKit
//

@protocol SGNumberArray <NSObject>
@required

//- (instancetype)initWithValues:(void *)values count:(NSUInteger)count;
- (instancetype)initWithNumberArray:(NSArray *)array;

//- (void *)values;
- (NSUInteger)count;

- (NSNumber *)numberAtIndex:(NSUInteger)idx;
- (NSArray *)numberArray;

@end


@interface SGNumberArray : NSObject <SGNumberArray, NSCopying>

// NSArray enumerate methods
- (void)enumerateObjectsAtIndexes:(NSIndexSet *)indexSet options:(NSEnumerationOptions)opts usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;

@end
