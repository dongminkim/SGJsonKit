//
//  SGJson.h
//
//  http://github.com/dongminkim/SGJsonKit
//

@protocol SGJson
@required
- (instancetype)initWithJSONObject:(id)jsonObject;
- (instancetype)initWithJSONTextData:(NSData*)jsonTextData;
- (instancetype)initWithJSONTextString:(NSString*)jsonTextString;
- (id)JSONObject;
- (NSData*)JSONTextData;
- (NSString*)JSONTextString;
@end
