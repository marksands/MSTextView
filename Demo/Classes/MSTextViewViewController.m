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
  NSString *sample = @"Follow me on twitter @marksands or check out the latest #Apple trends on http://www.twitter.com";
  
  MSTextView *textView = [[MSTextView alloc] initWithFrame:CGRectMake(10, 10, 300, 395)];
  textView.delegate = self;
  textView.font = [UIFont fontWithName:@"Helvetica" size:20];
  textView.text = sample;
  [self.view addSubview:textView];
  [textView release];
}

#pragma mark -
#pragma mark MSTextViewDelegate

- (void) handleURL:(NSURL*)url {  
  WebViewController *webview = [[WebViewController alloc] initWithURL:url];
  [self.navigationController pushViewController:webview animated:YES];
  [webview release];
}

#pragma mark -

- (void)dealloc {
  [super dealloc];
}

@end
