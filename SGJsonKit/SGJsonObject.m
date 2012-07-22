//
//  SGJsonObject.m
//  SGJsonKit
//
//  Created by 김 동민 on 7/21/12.
//  Copyright (c) 2012 TheVanity.org. All rights reserved.

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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

@implementation SGJsonObject

- (id)initWithJSONObject:(id)jsonObject
{
    NSDictionary *dic = (NSDictionary*)jsonObject;
    if (dic == nil) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"%@ initWithJSONObject: NOT with NSDictionary.", self];
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
            if (value == nil)
                value = [NSNull null];
            Class itemClass = [self classForPropertyNamed:propertyName];
            if ([itemClass conformsToProtocol:@protocol(SGJson)]) {
                value = [[itemClass alloc] initWithJSONObject:value];
            }
            [self performSelector:setter withObject:value];
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
        
        id value = [self performSelector:getter];
        if ([value conformsToProtocol:@protocol(SGJson)]) {
            value = [value JSONObject];
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

- (NSString *)description
{
    NSMutableString *propertyDescriptions = [[NSMutableString alloc] initWithFormat:@"%@{ ", [self class]];
    NSArray *propertyNames = [self copyPropertyNames];
    for (NSString *propertyName in propertyNames) {
        SEL getter = [self getterForPropertyNamed:propertyName];
        id value = [self performSelector:getter];
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

#pragma mark -

- (NSArray*)copyPropertyNames
{
	NSUInteger count = 0;
	objc_property_t *properties = class_copyPropertyList([self class], &count);
	NSMutableArray *propertyNameArray = [[NSMutableArray alloc] initWithCapacity:count]; 
	for (int i=0; i < count; i++)
	{
		NSString* propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
		[propertyNameArray addObject:propertyName];
	}
	free(properties);
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
            int len = q-p;
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
