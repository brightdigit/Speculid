//
//  UILoginViewController.h
//
//
//  Created by Leo G Dion on 11/4/13.
//
//

#import <UIKit/UIKit.h>

@interface UILoginViewController : UIViewController<UITextFieldDelegate> {
  IBOutlet UITextField * _userName;
  IBOutlet UITextField * _password;
  IBOutlet UIActivityIndicatorView * _activityView;

  IBOutletCollection(id) NSArray * _nextButtons;
}

- (IBAction) login:(id) sender;
- (IBAction) cancel:(id) sender;

@end
