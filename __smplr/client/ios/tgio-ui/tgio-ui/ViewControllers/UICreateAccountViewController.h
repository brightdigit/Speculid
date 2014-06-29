//
//  UICreateAccountViewController.h
//  tgio-ui
//
//  Created by Leo G Dion on 11/11/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUsernamePasswordViewController.h"

@interface UICreateAccountViewController : UIUsernamePasswordViewController {

}

- (IBAction) create:(id) sender;
- (IBAction) cancel:(id) sender;

@property (strong, nonatomic) NSString * key;
@property (strong, nonatomic) NSString * secret;

@end
