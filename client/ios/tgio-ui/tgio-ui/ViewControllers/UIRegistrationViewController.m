//
//  UIRegistrationViewController.m
//
//
//  Created by Leo G Dion on 11/4/13.
//
//

#import "UIRegistrationViewController.h"

@interface UIRegistrationViewController ()

@end

@implementation UIRegistrationViewController

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

- (BOOL) validateEmail:(NSString *)candidate
{
  NSString * emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
  NSPredicate * emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];

  return [emailTest evaluateWithObject:candidate];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

  return YES;
}

- (IBAction) register:(id)sender
{
  [UIApplication startActivity];
  [AppInterface registerEmailAddress:_emailAddress.text target:self action:@selector(onRegistration:)];
}

- (void) onRegistration:(id)result
{
  // if (result.isValid)
  [UIApplication  stopActivity];
  [self performSegueWithIdentifier:@"registration" sender:self];
  // [_activityView stopAnimating];
}

- (IBAction) cancel:(id)sender
{
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
