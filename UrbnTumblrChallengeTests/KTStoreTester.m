//
//  KTStoreTester.m
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 7/4/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KTPostStore.h"
#import "Post.h"

@interface KTStoreTester : XCTestCase

@end

@implementation KTStoreTester

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStoreCanAddNewPost
{
    Post *testPost = [[KTPostStore sharedStore]addNewPost];
    XCTAssertNotNil(testPost, @"test post made");
}



@end
