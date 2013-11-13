//
//  TgioClient.h
//  tgio-sdk
//
//  Created by Leo G Dion on 11/12/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TgioClient <NSObject>

+ (id<TgioClient>)connect:(NSString *) applicationId;
- (void) login:(id<LoginRequest>) request target:(id) target action:(SEL) selector;
- (void) register :(id<RegistrationRequest>) request target:(id) target action:(SEL) selector;

@end
