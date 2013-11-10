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

static NSRegularExpression * userNameRegularExpression = nil;

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

+ (BOOL) validateUserName:(NSString *)userName
{
  NSError * error;

  if (userNameRegularExpression == nil)
  {
    userNameRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[a-z][a-z0-9]{5,15}$" options:0 error:&error];

    NSLog(@"error: %@", error);
  }

  NSArray * matches = [userNameRegularExpression matchesInString:userName options:0 range:NSMakeRange(0, userName.length)];

  return matches.count > 0;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  NSString * userName;
  NSString * password;

  BOOL result = YES;

  if (textField == _userName)
  {
    userName = [textField.text stringByReplacingCharactersInRange:range withString:string];
    password = _password.text;
  }
  else
  {
    userName = _userName.text;
    password = [textField.text stringByReplacingCharactersInRange:range withString:string];
  }
  BOOL isValid = password.length >= 5 && [UILoginViewController validateUserName:userName];
  [_nextButton setEnabled:isValid];
  [_loginButton setEnabled:isValid];
  result = !(!isValid && textField == _userName  && userName.length > 15);
  return result;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
  if (textField == _userName)
  {
    [_password becomeFirstResponder];
  }
  else if (textField == _password)
  {
    [textField resignFirstResponder];
  }
  return YES;
}

- (IBAction) login:(id)sender
{
  [UIApplication startActivity];
  [AppInterface loginUser:_userName.text withPassword:_password.text target:self action:@selector(onLogin:)];
  [self.view endEditing:YES];
}

- (void) onLogin:(id)result
{
  [self performSegueWithIdentifier:@"home" sender:self];
  [UIApplication stopActivity];
}

- (IBAction) cancel:(id)sender
{
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
