//
//  SGDemoRoot.h
//  SGJsonKit-Demo
//
//  Created by 김 동민 on 7/21/12.
//  Copyright (c) 2012 TheVanity.org. All rights reserved.
//

#import "SGJsonKit.h"

@class SGDemoMembers;

@interface SGDemoRoot : SGJsonObject
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSNumber *buildCount;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) SGDemoMembers *members;
@end
