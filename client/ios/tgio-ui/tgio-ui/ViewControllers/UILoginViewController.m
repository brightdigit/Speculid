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

- (void) viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void) didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction) login:(id)sender
{
  [UIApplication startActivity];
  [AppInterface login:nil target:self action:@selector(onLogin:)];
//  [AppInterface login:_userName.text withPassword:_password.text target:self action:@selector(onLogin:)];
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
