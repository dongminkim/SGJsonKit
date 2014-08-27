//
//  SGJsonObject.h
//
//  http://github.com/dongminkim/SGJsonKit
//

#import <Foundation/Foundation.h>
#import "SGJson.h"

@interface SGJsonObject : NSObject <SGJson, NSCopying>

- (id)valueForEqualityCheck;
- (void)update:(SGJsonObject *)sourceObject;

@end
