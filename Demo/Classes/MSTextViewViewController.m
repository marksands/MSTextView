//
//  MSTextViewViewController.m
//  MSTextView
//
//  Created by Mark Sands on 11/21/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MSTextViewViewController.h"
#import "WebViewController.h"

@implementation MSTextViewViewController

- (void) viewDidLoad
{
  NSString *sample = @"Check out my GitHub page http://github.com/marksands or go to http://google.com instead. \n\nOptionally, try out a news site such as http://yahoo.com or http://cnn.com for great good!";

  MSTextView *textView = [[[MSTextView alloc] initWithFrame:CGRectMake(10, 10, 300, 395)] autorelease];
  textView.delegate = self;
  textView.text = sample;
  textView.font = [UIFont fontWithName:@"Helvetica" size:20];
  [self.view addSubview:textView];
}

#pragma mark -
#pragma mark MSTextViewDelegate

- (void) didSelectURL:(NSURL*)url {
  WebViewController *webview = [[WebViewController alloc] initWithURL:url];
  [self.navigationController pushViewController:webview animated:YES];
  [webview release];
}

#pragma mark -

- (void)dealloc {
  [super dealloc];
}

@end
