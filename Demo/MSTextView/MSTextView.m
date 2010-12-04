//
//  WBTextView.m
//  MSTextView
//
//  Created by Mark Sands on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSTextView.h"

@implementation MSTextView

@synthesize text = _text;
@synthesize _aWebView;
@synthesize delegate;

- (id) initWithFrame:(CGRect)frame
{
  if ( (self = [super initWithFrame:frame]) ) {
    _aWebView = [[UIWebView alloc] initWithFrame:self.bounds];
    _aWebView.delegate = self;
    [self addSubview:_aWebView];
    // this turns off scrolling in the UIWebView
    for (id subview in _aWebView.subviews)
      if ([[subview class] isSubclassOfClass:[UIScrollView class]])
        ((UIScrollView *)subview).bounces = NO;
  }
  return self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  if( navigationType == UIWebViewNavigationTypeLinkClicked )
  {
    if ([(NSObject*)self.delegate respondsToSelector:@selector(handleURL:)]) {
      [self.delegate handleURL:request.URL];
    }
    
    return NO;
  }
  
  return YES;
}

- (void) layoutSubviews
{
  NSMutableString *sample = [NSMutableString stringWithString:_text];  
  
  NSString *linkRegex = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
  //NSString *hashRegex = @"[\\s]{1,}#{1}([^\\s]{2,})";
  //NSString *userRegex = @"@{1}([-A-Za-z0-9_]{2,})";
  
  NSError *error = NULL;
  NSRegularExpression *detector = [NSRegularExpression regularExpressionWithPattern:linkRegex options:0 error:&error];
  NSArray *links = [detector matchesInString:sample options:0 range:NSMakeRange(0, sample.length)];
  NSMutableArray *current = [NSMutableArray arrayWithArray:links];  
 
  for ( int i = 0; i < [links count]; i++ ) {
    
    NSTextCheckingResult *cr = [current objectAtIndex:0];
    
    NSString *url = [sample substringWithRange:cr.range];
    
    [sample replaceOccurrencesOfString:url withString:[NSString stringWithFormat:@"<a href=\"%@\">%@</a>", url, url] options:NSLiteralSearch range:NSMakeRange(0, sample.length)];
    
    current = [NSMutableArray arrayWithArray:[detector matchesInString:sample options:0 range:NSMakeRange(0, sample.length)]];
    [current removeObjectsInRange:NSMakeRange(0, ( (i+1) * 2 ))];
  }
  
  [sample replaceOccurrencesOfString:@"\n" withString:@"<br />" options:NSLiteralSearch range:NSMakeRange(0, sample.length)];
  
  NSString *embedHTML = @"\
  <html><head>\
  <style type=\"text/css\">\
  body {background-color: transparent;font-family: \"Helvetica\";font-size: 20px;color: black;}\
  a    { text-decoration:none; color:rgba(35,110,216,1); font-weight:bold;}\
  </style>\
  </head><body style=\"margin:0\">\
  %@\
  </body></html>";
  
  NSString *htmlString = [NSString stringWithFormat:embedHTML, sample];

  [_aWebView loadHTMLString:htmlString baseURL:nil];
}

- (void) dealloc
{
  [_text release]; 
  [_aWebView release];
  [super dealloc];
}

@end
