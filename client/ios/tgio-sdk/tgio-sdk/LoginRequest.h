//
//  LoginRequest.h
//  tgio-sdk
//
//  Created by Leo G Dion on 11/11/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginRequest <NSObject>

@end

@interface LoginRequest : NSObject<LoginRequest>

- (id) initWithUserName:(NSString *) userName andPassword:(NSString *) password;

@property (readonly, nonatomic) NSString * userName;
@property (readonly, nonatomic) NSString * password;

@end
