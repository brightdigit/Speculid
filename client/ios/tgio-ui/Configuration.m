//
//  Configuration.m
//  tgio-ui
//
//  Created by Leo G Dion on 11/5/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import "Configuration.h"
#import "Interface.h"

@implementation Configuration

+ (void) configure: (id<Interface>) interface {
    [interface initialize];
}

@end
