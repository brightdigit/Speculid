//
//  UICreateAccountViewController.m
//  tgio-ui
//
//  Created by Leo G Dion on 11/11/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import "UICreateAccountViewController.h"

@interface UICreateAccountViewController ()

@end

@implementation UICreateAccountViewController

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


- (IBAction) create:(id)sender
{
  [UIApplication startActivity];
  [AppInterface login:_userName.text withPassword:_password.text target:self action:@selector(onCreate:)];
  [self.view endEditing:YES];
}

- (void) onCreate:(id)result
{
  [self performSegueWithIdentifier:@"home" sender:self];
  [UIApplication stopActivity];
}

- (IBAction) cancel:(id)sender
{
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
