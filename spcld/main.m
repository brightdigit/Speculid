//
//  main.m
//  spcld
//
//  Created by Leo Dion on 9/26/16.
//
//

#import <Foundation/Foundation.h>
#import <Speculid/Speculid.h>

int main(int argc, const char * argv[]) {
  @autoreleasepool {
      // insert code here...
      NSLog(@"Hello, World!");
    NSArray *arguments = [[NSProcessInfo processInfo] arguments];
    if (arguments.count > 0) {
      NSString * path = arguments[1];
      
    }
    //NSString * path = (NSString *)NSProcessInfo.argv[1];
    /*
    let path = CommandLine.arguments[1]
    let speculidURL = URL(fileURLWithPath: path)
    
    if let document = SpeculidDocument(url: speculidURL) {

      SpeculidBuilder.shared.build(document: document, callback: {
        (error) in
     
        exit(error == nil ? 0 : 1)
      })
    */
  }
  
    return 0;
}
