//
//  MSTextViewViewController.m
//  MSTextView
//
//  Created by Mark Sands on 11/21/10.
//  Copyright Mark Sands 2010. All rights reserved.
//

#import "MSTextViewViewController.h"
#import "WebViewController.h"


@implementation MSTextViewViewController

- (void) viewDidLoad
{
  UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, 300, 100)];
  [self.view addSubview:sv];

  NSString *sample = @"Check out my GitHub page http://github.com/marksands or go to http://google.com instead. \n\nOptionally, try out a news site such as http://yahoo.com or http://cnn.com for great good!";

  MSTextView *textView = [[MSTextView alloc] initWithFrame:CGRectMake(10, 10, 300, 395)];
  textView.delegate = self;
  textView.font = [UIFont fontWithName:@"Helvetica" size:20];
  textView.text = sample;
  [sv addSubview:textView];
  //[self.view addSubview:textView];
  [textView release];
}

#pragma mark -
#pragma mark MSTextViewDelegate

- (void)handleURL:(NSURL*)url
{
  WebViewController *webview = [[WebViewController alloc] initWithURL:url];
  [self.navigationController pushViewController:webview animated:YES];
  [webview release];
}

- (void)textViewDidAdjustHeight:(MSTextView *)textView
{
  UIScrollView *sv = [[self.view subviews] objectAtIndex:0];
  sv.contentSize = textView.frame.size;
}

#pragma mark -

- (void)dealloc {
  [super dealloc];
}

@end