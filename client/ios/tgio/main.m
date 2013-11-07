//
//  main.m
//  tgio
//
//  Created by Leo G Dion on 10/26/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//
#import <Pixate/Pixate.h>
#import <UIKit/UIKit.h>
#import "../tgio-ui/Configuration.h"
#import "AppDelegate.h"

#if MOCK
#import "../tgio-mockInterface/tgio-mockInterface/Interface.h"
#else
#import "../tgio-interface/tgio-interface/Interface.h"
#endif

int main(int argc, char * argv[])
{
  @autoreleasepool {
    [Pixate licenseKey:@"J5R0V-BEGQB-53PNS-01QV9-0VP50-1R58F-UOTBE-SV1DG-10BA6-N0HH6-EFGGH-H9BKU-5L5VC-0H99D-0IMMP-5E" forUser:@"leogdion@brightdigit.com"];
    [Configuration configure:[Interface instance]];
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
  }

}
