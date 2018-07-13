//
//  CarioSVGTests.m
//  CarioSVGTests
//
//  Created by Leo Dion on 6/28/18.
//

#import <XCTest/XCTest.h>
#import <rsvg.h>
#import "ImageHandleBuilder.h"

@interface CarioSVGTests : XCTestCase

@end

@implementation CarioSVGTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  ImageHandleBuilder * builder = [[ImageHandleBuilder alloc] init];
//  builder rsvgHandleFromURL:<#(nonnull NSURL *)#>
  NSBundle * bundle = [NSBundle bundleForClass:[self class]];
  NSURL * url = [bundle URLForResource:@"geometry" withExtension:@"svg"];
  NSLog(@"%@", url);
  RsvgHandle * handle = [builder rsvgHandleFromURL:url];
  NSLog(@"%@", handle);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
