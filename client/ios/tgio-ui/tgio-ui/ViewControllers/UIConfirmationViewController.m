//
//  ConfirmationViewController.m
//  tgio-ui
//
//  Created by Leo G Dion on 11/9/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import "UIConfirmationViewController.h"

@interface ConfirmationViewController ()

@end

@implementation ConfirmationViewController

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
  if ([AppInterface respondsToSelector:@selector(type)] && [AppInterface type] == MockInterfaceType)
  {
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                     [self performSegueWithIdentifier:@"createUser" sender:self];
                   });
  }
}

- (void) didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
