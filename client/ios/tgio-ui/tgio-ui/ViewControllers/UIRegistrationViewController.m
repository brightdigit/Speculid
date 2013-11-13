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

static NSPredicate * emailTest = nil;

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
  if (emailTest == nil)
  {
    emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@",
                 @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
                 @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
                 @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
                 @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
                 @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
                 @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
                 @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"];
  }

  return [emailTest evaluateWithObject:candidate];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  NSString * emailAddress;

  if (_emailAddress == textField)
  {
    emailAddress = [textField.text stringByReplacingCharactersInRange:range withString:string];
  }
  else
  {
    emailAddress = _emailAddress.text;
  }

  BOOL isValid = [self validateEmail:emailAddress];

  _registerButton.enabled = isValid;
  _nextButton.enabled = isValid;

  return YES;
}

- (IBAction) register:(id)sender
{
  [UIApplication startActivity];
  [AppInterface register:nil target:self action:@selector(onRegistration:)];
  [_emailAddress resignFirstResponder];
}

- (void) onRegistration:(id)result
{
  [UIApplication  stopActivity];
  [self performSegueWithIdentifier:@"registration" sender:self];
}

- (IBAction) cancel:(id)sender
{
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
