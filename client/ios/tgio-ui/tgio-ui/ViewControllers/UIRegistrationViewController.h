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
  IBOutletCollection(id) NSArray * _nextButtons;
}

- (IBAction) register :(id) sender;
- (IBAction) cancel:(id) sender;

@end
