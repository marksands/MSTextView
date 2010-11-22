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
  NSString *sample = @"Check out my GitHub page http://github.com/marksands or go to http://google.com instead. Optionally, try out a news site such as http://yahoo.com or http://cnn.com";

  MSTextView *textView = [[MSTextView alloc] initWithFrame:CGRectMake(10, 10, 310, 480)];
  textView.delegate = self;
  textView.text = sample;
  [self.view addSubview:textView];  
  [textView release];  
}

#pragma mark -
#pragma mark MSTextViewDelegate

- (void) handleURL:(NSString*)url {
  WebViewController *webview = [[WebViewController alloc] initWithURL:[NSURL URLWithString:url]];
  [self.navigationController pushViewController:webview animated:YES];
  [webview release];
}

#pragma mark -

- (void)dealloc {
    [super dealloc];
}

@end
