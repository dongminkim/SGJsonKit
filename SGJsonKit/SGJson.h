//
//  SGJson.h
//
//  http://github.com/dongminkim/SGJsonKit
//

@protocol SGJson
@required
- (id)initWithJSONObject:(id)jsonObject;
- (id)initWithJSONTextData:(NSData*)jsonTextData;
- (id)initWithJSONTextString:(NSString*)jsonTextString;
- (id)JSONObject;
- (NSData*)JSONTextData;
- (NSString*)JSONTextString;
@end
