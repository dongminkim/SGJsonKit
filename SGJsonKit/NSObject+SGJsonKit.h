//
//  NSObject+SGJsonKit.h
//
//  http://github.com/dongminkim/SGJsonKit
//

#import <Foundation/Foundation.h>

@interface NSObject (SGJsonKit)

- (void)enumeratePropertyKeysUsingBlock:(void (^)(NSString *key))block;
- (void)enumeratePropertyKeysUsingBlock:(void (^)(NSString *key))block untilSuperClass:(Class)superCls;
- (void)enumeratePropertyKeysAndValuesUsingBlock:(void (^)(NSString *key, id value))block;
- (void)enumeratePropertyKeysAndValuesUsingBlock:(void (^)(NSString *key, id value))block untilSuperClass:(Class)superCls;

- (Class)classForPropertyKey:(NSString *)key;
- (SEL)getterForPropertyKey:(NSString *)key;
- (SEL)setterForPropertyKey:(NSString *)key;

@end
