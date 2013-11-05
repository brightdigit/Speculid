//
//  UILoginViewController.h
//  
//
//  Created by Leo G Dion on 11/4/13.
//
//

#import <UIKit/UIKit.h>

@interface UILoginViewController : UIViewController {
    IBOutlet UITextField * userName;
    IBOutlet UITextField * password;
}

- (IBAction) login:(id) sender;

@end
