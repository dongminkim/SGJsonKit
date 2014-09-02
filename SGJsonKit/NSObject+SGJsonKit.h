//
//  NSObject+SGJsonKit.h
//
//  http://github.com/dongminkim/SGJsonKit
//

#import <Foundation/Foundation.h>

@interface NSObject (SGJsonKit)

+ (NSString *)describe:(id)object;
+ (NSString *)describeProperties:(id)object;
+ (NSString *)describeProperties:(id)object untilSuperClass:(Class)superClass;
+ (NSString *)describeDictionaryItems:(id)object;
+ (NSString *)describeArrayItems:(id)object;

- (void)enumeratePropertyKeysUsingBlock:(void (^)(NSString *key))block;
- (void)enumeratePropertyKeysUsingBlock:(void (^)(NSString *key))block untilSuperClass:(Class)superClass;
- (void)enumeratePropertyKeysAndValuesUsingBlock:(void (^)(NSString *key, id value))block;
- (void)enumeratePropertyKeysAndValuesUsingBlock:(void (^)(NSString *key, id value))block untilSuperClass:(Class)superClass;

- (Class)classForPropertyKey:(NSString *)key;
- (SEL)getterForPropertyKey:(NSString *)key;
- (SEL)setterForPropertyKey:(NSString *)key;

@end
