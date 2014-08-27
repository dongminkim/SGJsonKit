//
//  SGJsonObject.m
//
//  http://github.com/dongminkim/SGJsonKit
//

#import <objc/runtime.h>

SEL property_getMethod(objc_property_t property, BOOL isSetter)
{
	const char* attrs = property_getAttributes(property);
	if (attrs == nil)
		return nil;
	
	const char* needle = isSetter ? ",S" : ",G";
	const char* p = strstr(attrs, needle);
	if (p == nil)
		return nil;
	
	p += 2;
	const char *e = strchr( p, ',' );
	if (e == p)
		return nil;
	if (e == nil)
		return (sel_getUid(p));
	
	int len = (int)(e - p);
	char* selPtr = malloc(len + 1);
	memcpy(selPtr, p, len);
	selPtr[len] = '\0';
	SEL sel = sel_getUid(selPtr);
	free(selPtr);
	return sel;
}

SEL property_getGetter(objc_property_t property)
{
	SEL getter = property_getMethod(property, FALSE);
	if (getter == nil)
	{
		NSString* propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
		NSString* getterName = propertyName;
		getter = NSSelectorFromString(getterName);
	}
	return getter;
}

SEL property_getSetter(objc_property_t property)
{
	SEL setter = property_getMethod(property, TRUE);
	if (setter == nil)
	{
		NSString* propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
		NSString* setterName = [NSString stringWithFormat:@"set%@%@:",
								[[propertyName substringToIndex:1] uppercaseString],
								[propertyName substringFromIndex:1]];
		setter = NSSelectorFromString(setterName);
	}
	return setter;
}


#pragma mark -
#import "SGJsonKit.h"

@interface SGJsonObject ()
- (NSArray*)copyPropertyNames;
- (Class)classForPropertyNamed:(NSString*)name;
- (SEL)getterForPropertyNamed:(NSString*)name;
- (SEL)setterForPropertyNamed:(NSString*)name;
@end

@implementation SGJsonObject

- (id)init
{
    self = [super init];
    return self;
}

- (id)initWithJSONObject:(id)jsonObject
{
    NSDictionary *dic = (NSDictionary*)jsonObject;
    if (dic == nil) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"%@ initWithJSONObject: param is %@ NOT %@.", self, [jsonObject class], [NSDictionary class]];
    }

    self = [super init];
    if (self != nil) {
        NSArray *propertyNames = [self copyPropertyNames];
        for (NSString *propertyName in propertyNames)
        {
            SEL setter = [self setterForPropertyNamed:propertyName];
            if (setter == nil) {
                [NSException raise:NSInternalInconsistencyException
                            format:@"%@ has property '%@' with no setter.", self, propertyName];
            }
            
            id value = [dic objectForKey:propertyName];
            if (value == nil || [value isKindOfClass:[NSNull class]]) {
                value = nil;
            } else {
                Class itemClass = [self classForPropertyNamed:propertyName];
                if ([itemClass conformsToProtocol:@protocol(SGJson)]) {
                    value = [[itemClass alloc] initWithJSONObject:value];
                } else if ([itemClass conformsToProtocol:@protocol(SGNumberArray)]) {
                    value = [[itemClass alloc] initWithNumberArray:value];
                }
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//                [self performSelector:setter withObject:value];
//#pragma clang diagnostic pop
                [self setValue:value forKey:propertyName];
            }
        }
    }
    return self;
}

- (id)initWithJSONTextData:(NSData*)jsonTextData
{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonTextData options:NSJSONReadingAllowFragments error:&error];
    if (jsonObject == nil) {
        NSLog(@"error on SGJsonWithData: %@", error);
    }
    return [self initWithJSONObject:jsonObject];
}

- (id)initWithJSONTextString:(NSString*)jsonTextString
{
    NSData *data = [jsonTextString dataUsingEncoding:NSUTF8StringEncoding];
    return [self initWithJSONTextData:data];
}

- (id)JSONObject
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSArray *propertyNames = [self copyPropertyNames];
    for (NSString *propertyName in propertyNames)
    {
        SEL getter = [self getterForPropertyNamed:propertyName];
        if (getter == nil) {
            [NSException raise:NSInternalInconsistencyException
                        format:@"%@ has property '%@' with no getter.", self, propertyName];
        }
        
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//        id value = [self performSelector:getter];
//#pragma clang diagnostic pop
        id value = [self valueForKey:propertyName];
        
        if (value == nil || [value isKindOfClass:[NSNull class]]) {
            value = [NSNull null];
        } else if ([value conformsToProtocol:@protocol(SGJson)]) {
            value = [value JSONObject];
        } else if ([value conformsToProtocol:@protocol(SGNumberArray)]) {
            value = [value numberArray];
        }
        [dic setObject:value forKey:propertyName];
    }
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
    NSMutableString *propertyDescriptions = [[NSMutableString alloc] initWithFormat:@"%@{ ", [self class]];
    NSArray *propertyNames = [self copyPropertyNames];
    for (NSString *propertyName in propertyNames) {
//        SEL getter = [self getterForPropertyNamed:propertyName];
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//        id value = [self performSelector:getter];
//#pragma clang diagnostic pop
        id value = [self valueForKey:propertyName];
        
        [propertyDescriptions appendFormat:@"%@:%@, ", propertyName, value];
    }
    [propertyDescriptions appendFormat:@"}"];
    return propertyDescriptions;
}

- (id)copyWithZone:(NSZone *)zone
{
    SGJsonObject *copy = [[[self class] allocWithZone:zone] initWithJSONObject:[self JSONObject]];
    return copy;
}

- (void)update:(SGJsonObject *)sourceObject
{
    NSArray *propertyNames = [self copyPropertyNames];
    for (NSString *propertyName in propertyNames)
    {
//        SEL setter = [self setterForPropertyNamed:propertyName];
//        if (setter == nil) {
//            [NSException raise:NSInternalInconsistencyException
//                        format:@"%@ has property '%@' with no setter.", self, propertyName];
//        }
//        SEL getter = [sourceObject getterForPropertyNamed:propertyName];
//        if (getter == nil) {
//            [NSException raise:NSInternalInconsistencyException
//                        format:@"%@ has property '%@' with no getter.", sourceObject, propertyName];
//        }
//        
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//        id value = [sourceObject performSelector:getter];
//        [self performSelector:setter withObject:value];
//#pragma clang diagnostic pop
        id value = [self valueForKey:propertyName];
        [self setValue:value forKey:propertyName];
    }
}

#pragma mark -

- (NSArray*)copyPropertyNames
{
    NSMutableArray *propertyNameArray = [[NSMutableArray alloc] init];
    for (Class class=[self class]; [class isSubclassOfClass:[SGJsonObject class]]; class=[class superclass]) {
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList(class, &count);
        for (int i=0; i < count; i++)
        {
            NSString* propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
            [propertyNameArray addObject:propertyName];
        }
        free(properties);
    }
	return propertyNameArray;
}

- (Class)classForPropertyNamed:(NSString*)name
{
	objc_property_t property = class_getProperty([self class], [name cStringUsingEncoding:NSUTF8StringEncoding]);
    const char* attrs = property_getAttributes(property);
    const char* p = strstr(attrs, "T@\"");
    if (p == attrs) {
        p += 3;
        const char* q = strstr(p, "\"");
        if (q > p) {
            long len = q-p;
            if (len <= 100) {
                char buf[128];
                strncpy(buf, p, len);
                buf[len] = '\0';
                NSString *className = [NSString stringWithFormat:@"%s", buf];
                Class c = NSClassFromString(className);
                return c;
            }
        }
    }
    return nil;
}

- (SEL)getterForPropertyNamed:(NSString*)name
{
	objc_property_t property = class_getProperty([self class], [name cStringUsingEncoding:NSUTF8StringEncoding]);
	SEL getter = property_getGetter(property);
	if (getter != nil && [self respondsToSelector:getter] == NO)
		getter = nil;
	return getter;
}

- (SEL)setterForPropertyNamed:(NSString*)name
{
	objc_property_t property = class_getProperty([self class], [name cStringUsingEncoding:NSUTF8StringEncoding]);
	SEL setter = property_getSetter(property);
	if (setter != nil && [self respondsToSelector:setter] == NO)
		setter = nil;
	return setter;
}

@end
