//
//  UIView+Activity.m
//  tgio-ui
//
//  Created by Leo G Dion on 11/8/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//
#import "UIApplication+Activity.h"

@implementation UIApplication (Activity)

const NSInteger tag = 22848489;

+ (UIWindow *) keyWindow
{
  return [[UIApplication sharedApplication] keyWindow];
}

+ (UIActivityIndicatorView *) activityView
{
  UIActivityIndicatorView * result;

  result = (UIActivityIndicatorView *) [self.keyWindow viewWithTag:tag];

  if (result == nil)
  {
    result = [self buildView];
  }

  return result;
}

+ (UIActivityIndicatorView *) buildView
{
  UIActivityIndicatorView * view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

  view.hidesWhenStopped = YES;
  view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
  view.tag = tag;
  view.alpha = 0;
  [view setFrame:self.keyWindow.bounds];

  [self.keyWindow addSubview:view];
  [self.keyWindow bringSubviewToFront:view];

  return view;
}

+ (void) startActivity
{
  [[self activityView] startAnimating];
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.5];
  [[self activityView] setAlpha:1.0];
  [UIView commitAnimations];
}

+ (void) stopActivity
{
  [[self activityView] stopAnimating];
  [[self activityView] removeFromSuperview];
}

@end
