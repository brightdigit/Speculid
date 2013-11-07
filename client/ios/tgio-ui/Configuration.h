//
//  Configuration.h
//  tgio-ui
//
//  Created by Leo G Dion on 11/5/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Interface;

@interface Configuration : NSObject

+ (id<Interface>)interface;
+ (void) configure:(id<Interface>)interface;

@end
