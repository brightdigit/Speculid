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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) login:(id) sender {
//    [AppInterface login:]
}

- (IBAction) cancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
