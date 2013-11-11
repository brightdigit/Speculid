//
//  Interface.h
//  tgio-ui
//
//  Created by Leo G Dion on 11/5/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Interface <NSObject>

typedef enum
{
  ProductionInterfaceType,
  MockInterfaceType
} InterfaceType;

- (void) initialize;
- (void) login:(NSString *) name withPassword:(NSString *) password target:(id) target action:(SEL) selector;
- (void) registerEmailAddress:(NSString *) emailAddress target:(id) target action:(SEL) selector;

@optional
- (InterfaceType) type;

+ (id<Interface>)instance;

@end
