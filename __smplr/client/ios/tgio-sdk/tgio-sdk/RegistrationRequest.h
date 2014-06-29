//
//  RegistrationRequest.h
//  tgio-sdk
//
//  Created by Leo G Dion on 11/11/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RegistrationRequest <NSObject>

@end

@interface RegistrationRequest : NSObject<RegistrationRequest>

- (id) initWithEmailAddress:(NSString *) emailAddress;

@property (readonly, nonatomic) NSString * emailAddress;

@end