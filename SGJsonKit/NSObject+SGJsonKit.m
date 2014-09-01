//
//  NSObject+SGJsonKit.m
//
//  http://github.com/dongminkim/SGJsonKit
//

#import <objc/runtime.h>

static SEL property_getMethod(objc_property_t property, BOOL isSetter)
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

static SEL property_getGetter(objc_property_t property)
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

static SEL property_getSetter(objc_property_t property)
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

#import "NSObject+SGJsonKit.h"

@implementation NSObject (SGJsonKit)

- (void)enumeratePropertyKeysUsingBlock:(void (^)(NSString *))block
{
    [self enumeratePropertyKeysUsingBlock:block untilSuperClass:self.superclass];
}

- (void)enumeratePropertyKeysUsingBlock:(void (^)(NSString *))block untilSuperClass:(Class)superCls
{
    unsigned int outCount, i;
    for (Class cls = self.class; cls != superCls; cls = cls.superclass) {
        objc_property_t *properties = class_copyPropertyList(cls, &outCount);
        for (i = 0; i < outCount; i++) {
            NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
            if (block) {
                block(key);
            }
        }
        free(properties);
    }
}

- (void)enumeratePropertyKeysAndValuesUsingBlock:(void (^)(NSString *, id))block
{
    [self enumeratePropertyKeysAndValuesUsingBlock:block untilSuperClass:self.superclass];
}

- (void)enumeratePropertyKeysAndValuesUsingBlock:(void (^)(NSString *, id))block untilSuperClass:(Class)superCls
{
    [self enumeratePropertyKeysUsingBlock:^(NSString *key) {
        if (block) {
            id value = [self valueForKey:key];
            block(key, value);
        }
    } untilSuperClass:superCls];
}

- (Class)classForPropertyKey:(NSString *)key
{
	objc_property_t property = class_getProperty([self class], [key cStringUsingEncoding:NSUTF8StringEncoding]);
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

-(SEL)getterForPropertyKey:(NSString *)key
{
	objc_property_t property = class_getProperty([self class], [key cStringUsingEncoding:NSUTF8StringEncoding]);
	SEL getter = property_getGetter(property);
	if (getter != nil && [self respondsToSelector:getter] == NO)
		getter = nil;
	return getter;
}

- (SEL)setterForPropertyKey:(NSString *)key
{
	objc_property_t property = class_getProperty([self class], [key cStringUsingEncoding:NSUTF8StringEncoding]);
	SEL setter = property_getSetter(property);
	if (setter != nil && [self respondsToSelector:setter] == NO)
		setter = nil;
	return setter;
}

@end
