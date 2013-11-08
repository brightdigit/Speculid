//
//  UILoginViewController.m
//
//
//  Created by Leo G Dion on 11/4/13.
//
//

#import "UILoginViewController.h"

@interface UILoginViewController ()

@end

@implementation UILoginViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self)
  {
    // Custom initialization
  }
  return self;
}

- (void) viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void) didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  // _userName.text [a-z][a-z0-9-]
  return YES;
}

- (IBAction) login:(id)sender
{
  [UIApplication startActivity];
  [AppInterface loginUser:_userName.text withPassword:_password.text target:self action:@selector(onLogin:)];
}

- (void) onLogin:(id)result
{
  //  if (result.isValid) {
  [self performSegueWithIdentifier:@"home" sender:self];
  [UIApplication stopActivity];
}

- (IBAction) cancel:(id)sender
{
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
