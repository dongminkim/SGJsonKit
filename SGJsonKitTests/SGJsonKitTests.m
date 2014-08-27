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
    NSData *jsonData = [NSData dataWithContentsOfURL:[[NSBundle bundleForClass:self.class] URLForResource:@"testSample" withExtension:@"json"]];
    SGDemoRoot *demo = [[SGDemoRoot alloc] initWithJSONTextData:jsonData];
    NSLog(@"demo 0: %@", demo);
    
    NSString *generatedJsonTextString = [demo JSONTextString];
    NSLog(@"generated json text: %@", generatedJsonTextString);
    
    demo = [[SGDemoRoot alloc] initWithJSONTextString:generatedJsonTextString];
    NSLog(@"demo 1: %@", demo);
    
    [demo.members addObject:[[SGDemoMember alloc] initWithJSONTextString:@"{\"no\":103,\"name\":\"Susie Shin\"}"]];
    NSLog(@"demo 2: %@", demo);
    
    ((SGDemoMember*)demo.members[1]).lld = INT64_MAX;
    NSLog(@"demo 3: %@", demo);

    XCTAssertTrue([demo.version isKindOfClass:[NSString class]], @"#1");
    XCTAssertTrue([demo.version isEqualToString:@"1.0.0"], @"#2");
    XCTAssertTrue(demo.title == nil, @"#3");
    XCTAssertTrue(demo.desc == nil, @"#4");
    XCTAssertTrue([[demo.members[0] no] isEqualToNumber:[NSNumber numberWithInt:101]], @"#5-1");
    XCTAssertTrue([[demo.members[0] name] isEqualToString:@"Dongmin Kim"], @"#5-2");
    XCTAssertTrue([demo.members[0] lld] == 1234567890, @"#5-3");
    XCTAssertTrue([[demo.members[1] no] isEqualToNumber:[NSNumber numberWithInt:102]], @"#6-1");
    XCTAssertTrue([[demo.members[1] name] isEqualToString:@"Hyo Park"], @"#6-2");
    XCTAssertTrue([demo.members[1] lld] == INT64_MAX, @"#6-3");
    XCTAssertTrue([[demo.members[2] no] isEqualToNumber:[NSNumber numberWithInt:103]], @"#7-1");
    XCTAssertTrue([[demo.members[2] name] isEqualToString:@"Susie Shin"], @"#7-2");
    XCTAssertTrue([demo.members[2] lld] == 0, @"#7-3");
    XCTAssertTrue(demo.topScores.count == 3, @"#8-1");
    XCTAssertTrue(demo.topScores.values[0] == 1234567890L, @"#8-2");
    XCTAssertTrue(demo.topScores.values[1] == 7907170000L, @"#8-3");
    XCTAssertTrue(demo.topScores.values[2] == -987654321L, @"#8-4");
}

@end
