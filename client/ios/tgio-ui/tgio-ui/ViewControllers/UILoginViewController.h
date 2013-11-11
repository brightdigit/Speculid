//
//  UILoginViewController.h
//
//
//  Created by Leo G Dion on 11/4/13.
//
//

#import <UIKit/UIKit.h>
#import "UIUsernamePasswordViewController.h"

@interface UILoginViewController : UIUsernamePasswordViewController {
}

- (IBAction) login:(id) sender;
- (IBAction) cancel:(id) sender;

@end
