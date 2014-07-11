//
//  UIRegistrationViewController.h
//
//
//  Created by Leo G Dion on 11/4/13.
//
//

#import <UIKit/UIKit.h>

@interface UIRegistrationViewController : UIViewController {
  IBOutlet UITextField * _emailAddress;

  IBOutlet UIBarButtonItem * _nextButton;
  IBOutlet UIButton * _registerButton;
}

- (IBAction) register :(id) sender;
- (IBAction) cancel:(id) sender;

@end
