//
//  TgioClient.h
//  tgio-sdk
//
//  Created by Leo G Dion on 11/12/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TgioAppClient;

@protocol TgioClient <NSObject>

- (id<TgioAppClient>)connect:(NSString *) applicationId;

@end
