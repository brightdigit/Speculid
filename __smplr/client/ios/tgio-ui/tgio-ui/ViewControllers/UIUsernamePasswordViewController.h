//
//  UILoginViewController.h
//
//
//  Created by Leo G Dion on 11/4/13.
//
//

#import <UIKit/UIKit.h>

@interface UIUsernamePasswordViewController : UIViewController<UITextFieldDelegate> {
  IBOutlet UITextField * _userName;
  IBOutlet UITextField * _password;

  IBOutlet UIButton * _button;
  IBOutlet UIBarButtonItem * _nextButton;
}

@end
