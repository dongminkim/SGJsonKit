//
//  SGJsonObject.m
//
//  http://github.com/dongminkim/SGJsonKit
//

#import "SGJsonKit.h"
#import "NSObject+SGJsonKit.h"

@implementation SGJsonObject

- (instancetype)init
{
    self = [super init];
    return self;
}

- (instancetype)initWithJSONObject:(id)jsonObject
{
    NSDictionary *dic = (NSDictionary*)jsonObject;
    if (dic == nil) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"%@ initWithJSONObject: param is %@ NOT %@.", self, [jsonObject class], [NSDictionary class]];
    }

    self = [super init];
    if (self != nil) {
        [self enumeratePropertyKeysUsingBlock:^(NSString *key) {
            id value = [dic objectForKey:key];
            if (value == nil || [value isKindOfClass:[NSNull class]]) {
                value = nil;
            } else {
                Class itemClass = [self classForPropertyKey:key];
                if ([itemClass conformsToProtocol:@protocol(SGJson)]) {
                    value = [[itemClass alloc] initWithJSONObject:value];
                } else if ([itemClass conformsToProtocol:@protocol(SGNumberArray)]) {
                    value = [[itemClass alloc] initWithNumberArray:value];
                }
                [self setValue:value forKey:key];
            }
        } untilSuperClass:SGJsonObject.class];
    }
    return self;
}

- (instancetype)initWithJSONTextData:(NSData*)jsonTextData
{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonTextData options:NSJSONReadingAllowFragments error:&error];
    if (jsonObject == nil) {
        NSLog(@"error on SGJsonWithData: %@", error);
    }
    return [self initWithJSONObject:jsonObject];
}

- (instancetype)initWithJSONTextString:(NSString*)jsonTextString
{
    NSData *data = [jsonTextString dataUsingEncoding:NSUTF8StringEncoding];
    return [self initWithJSONTextData:data];
}

- (id)JSONObject
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [self enumeratePropertyKeysAndValuesUsingBlock:^(NSString *key, id value) {
        if (value == nil || [value isKindOfClass:[NSNull class]]) {
            value = [NSNull null];
        } else if ([value conformsToProtocol:@protocol(SGJson)]) {
            value = [value JSONObject];
        } else if ([value conformsToProtocol:@protocol(SGNumberArray)]) {
            value = [value numberArray];
        }
        [dic setObject:value forKey:key];
    } untilSuperClass:SGJsonObject.class];
    return dic;
}

- (NSData*)JSONTextData
{
    id jsonObject = [self JSONObject];
    NSError *error = nil;
    NSData *jsonTextData = [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:&error];
    return jsonTextData;
}

- (NSString*)JSONTextString
{
    NSData *jsonTextData = [self JSONTextData];
    NSString *jsonTextString = [[NSString alloc] initWithData:jsonTextData encoding:NSUTF8StringEncoding];
    return jsonTextString;    
}

- (id)valueForEqualityCheck
{
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (![object isMemberOfClass:[self class]])
        return NO;
    
    id value = [self valueForEqualityCheck];
    if (value == self)
        return [super isEqual:object];

    return [value isEqual:[object valueForEqualityCheck]];
}

- (NSString *)description
{
    NSString *desc = [NSObject describeProperties:self untilSuperClass:SGJsonObject.class];
    return desc;
}

- (id)copyWithZone:(NSZone *)zone
{
    SGJsonObject *copy = [[[self class] allocWithZone:zone] initWithJSONObject:[self JSONObject]];
    return copy;
}

- (void)update:(SGJsonObject *)sourceObject
{
    [self enumeratePropertyKeysUsingBlock:^(NSString *key) {
        id value = [sourceObject valueForKey:key];
        [self setValue:value forKey:key];
    } untilSuperClass:SGJsonObject.class];
}

@end
