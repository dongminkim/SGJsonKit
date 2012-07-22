//
//  SGJsonKitTests.m
//  SGJsonKitTests
//
//  Created by 김 동민 on 7/22/12.
//  Copyright (c) 2012 Shift Partners. All rights reserved.
//

#import "SGJsonKitTests.h"
#import "SGDemoRoot.h"
#import "SGDemoMembers.h"
#import "SGDemoMember.h"

@implementation SGJsonKitTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testSGJsonKit_01
{
    NSString *jsonTextString = @"{\"version\":\"1.0.0\",\"desc\":null,\"members\":[{\"no\":101,\"name\":\"Dongmin Kim\"}, {\"no\":102,\"name\":\"Hyo Park\"}]}";
    SGDemoRoot *demo = [[SGDemoRoot alloc] initWithJSONTextString:jsonTextString];
    NSLog(@"demo 0: %@", demo);
    
    NSString *generatedJsonTextString = [demo JSONTextString];
    NSLog(@"generated json text: %@", generatedJsonTextString);
    
    demo = [[SGDemoRoot alloc] initWithJSONTextString:generatedJsonTextString];
    NSLog(@"demo 1: %@", demo);
    
    [demo.members addObject:[[SGDemoMember alloc] initWithJSONTextString:@"{\"no\":103,\"name\":\"Susie Shin\"}"]];
    NSLog(@"demo 2: %@", demo);

    STAssertTrue([demo.version isKindOfClass:[NSString class]], @"#1");
    STAssertTrue([demo.version isEqualToString:@"1.0.0"], @"#2");
    STAssertTrue([demo.title isKindOfClass:[NSNull class]], @"#3");
    STAssertTrue([demo.desc isKindOfClass:[NSNull class]], @"#4");
    STAssertTrue([[[(NSArray*)demo.members objectAtIndex:0] no] isEqualToNumber:[NSNumber numberWithInt:101]], @"#5");
    STAssertTrue([[[(NSArray*)demo.members objectAtIndex:0] name] isEqualToString:@"Dongmin Kim"], @"#6");
    STAssertTrue([[[(NSArray*)demo.members objectAtIndex:1] no] isEqualToNumber:[NSNumber numberWithInt:102]], @"#7");
    STAssertTrue([[[(NSArray*)demo.members objectAtIndex:1] name] isEqualToString:@"Hyo Park"], @"#8");
    STAssertTrue([[[(NSArray*)demo.members objectAtIndex:2] no] isEqualToNumber:[NSNumber numberWithInt:103]], @"#9");
    STAssertTrue([[[(NSArray*)demo.members objectAtIndex:2] name] isEqualToString:@"Susie Shin"], @"#10");
}

@end
