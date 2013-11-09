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

//  IBOutletCollection(NSObject) NSArray * _nextButtons;
  IBOutlet UIButton * _loginButton;
  IBOutlet UIBarButtonItem * _nextButton;
}

- (IBAction) login:(id) sender;
- (IBAction) cancel:(id) sender;

@end
