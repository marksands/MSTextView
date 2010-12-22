//
//  WBTextView.m
//  MSTextView
//
//  Created by Mark Sands on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSTextView.h"

#define kFont [UIFont fontWithName:@"Helvetica" size:20]
#define kBackgroundColor [UIColor clearColor]

@interface MSTextView (PrivateMethods)
- (NSString *) linkRegex;
- (NSString *) twitterRegex;
- (NSString *) hashtagRegex;
- (CGFloat)    fontSize;
- (NSString *) fontName;
- (NSString *) bgColor;
- (NSString *) embedHTMLWithFontName:(NSString *)fontName 
                                size:(CGFloat)size 
                                text:(NSString *)theText;
@end

@implementation MSTextView

@synthesize text = _text;
@synthesize font = _font;
@synthesize backgroundColor =_backgroundColor;
@synthesize _aWebView;
@synthesize delegate;

#pragma mark -
#pragma mark MSTextView

- (id) initWithFrame:(CGRect)frame
{
  if ( (self = [super initWithFrame:frame]) ) {
    _aWebView = [[UIWebView alloc] initWithFrame:self.bounds];
    _aWebView.delegate = self;
    [self addSubview:_aWebView];

    _font = kFont;
    _backgroundColor = kBackgroundColor;

    // this turns off scrolling in the UIWebView
    for (id subview in _aWebView.subviews)
      if ([[subview class] isSubclassOfClass:[UIScrollView class]]) {
        ((UIScrollView *)subview).bounces = NO;
        ((UIScrollView *)subview).scrollEnabled = NO;
      }
  }

  return self;
}

- (void) layoutSubviews
{
  NSMutableString *theText = [NSMutableString stringWithString:_text];

  // Handle URLs
  NSError *error = NULL;
  NSRegularExpression *detector = [NSRegularExpression regularExpressionWithPattern:[self linkRegex] options:0 error:&error];
  NSArray *links = [detector matchesInString:theText options:0 range:NSMakeRange(0, theText.length)];
  NSMutableArray *current = [NSMutableArray arrayWithArray:links];  

  for ( int i = 0; i < [links count]; i++ ) {
    NSTextCheckingResult *cr = [current objectAtIndex:0];
    NSString *url = [theText substringWithRange:cr.range];

    [theText replaceOccurrencesOfString:url 
                           withString:[NSString stringWithFormat:@"<a href=\"%@\">%@</a>", url, url] 
                              options:NSLiteralSearch 
                                range:NSMakeRange(0, theText.length)];

    current = [NSMutableArray arrayWithArray:[detector matchesInString:theText options:0 range:NSMakeRange(0, theText.length)]];
    [current removeObjectsInRange:NSMakeRange(0, ( (i+1) * 2 ))];
  }

  // Handle Twitter Usernames
  detector = [NSRegularExpression regularExpressionWithPattern:[self twitterRegex] options:0 error:&error];
  links = [detector matchesInString:theText options:0 range:NSMakeRange(0, theText.length)];
  current = [NSMutableArray arrayWithArray:links];  

  for ( int i = 0; i < [links count]; i++ ) {
    NSTextCheckingResult *cr = [current objectAtIndex:i];
    NSString *url = [theText substringWithRange:cr.range];

    [theText replaceOccurrencesOfString:url 
                             withString:[NSString stringWithFormat:@"<a href=\"http://twitter.com/%@\">%@</a>", [url stringByReplacingOccurrencesOfString:@"@" withString:@""], url]
                                options:NSLiteralSearch 
                                  range:NSMakeRange(0, theText.length)];
    current = [NSMutableArray arrayWithArray:[detector matchesInString:theText options:0 range:NSMakeRange(0, theText.length)]];
  }

  // Handle Twitter Hashtags
  detector = [NSRegularExpression regularExpressionWithPattern:[self hashtagRegex] options:0 error:&error];
  links = [detector matchesInString:theText options:0 range:NSMakeRange(0, theText.length)];
  current = [NSMutableArray arrayWithArray:links];  
  NSString *hashtagURL =   @"http://twitter.com/search?q=%23";
  //hashtagURL = [hashtagURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

  for ( int i = 0; i < [links count]; i++ ) {
    NSTextCheckingResult *cr = [current objectAtIndex:i];
    NSString *url = [theText substringWithRange:cr.range];
    NSString *nohashURL = [url stringByReplacingOccurrencesOfString:@"#" withString:@""];
    nohashURL = [nohashURL stringByReplacingOccurrencesOfString:@" " withString:@""];

    [theText replaceOccurrencesOfString:url 
                             withString:[NSString stringWithFormat:@"<a href=\"%@%@\">%@</a>", hashtagURL, nohashURL, url]
                                options:NSLiteralSearch 
                                  range:NSMakeRange(0, theText.length)];
    current = [NSMutableArray arrayWithArray:[detector matchesInString:theText options:0 range:NSMakeRange(0, theText.length)]];
  }

  [theText replaceOccurrencesOfString:@"\n" withString:@"<br />" options:NSLiteralSearch range:NSMakeRange(0, theText.length)];

  [_aWebView loadHTMLString:[self embedHTMLWithFontName:[self fontName] 
                                                   size:[self fontSize] 
                                                   text:theText]
                    baseURL:nil];
}

#pragma mark -
#pragma mark UIWebView

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

#pragma mark -
#pragma mark UIFont

- (CGFloat) fontSize
{
  return [_font pointSize];
}

- (NSString *) fontName
{
  return [_font fontName];
}

#pragma mark -
#pragma mark UI

- (NSString *) embedHTMLWithFontName:(NSString *)fontName 
                                size:(CGFloat)size 
                                text:(NSString *)theText
{
  NSString *embedHTML = @"\
  <html><head>\
  <style type=\"text/css\">\
  body {background-color: rgba(%@);font-family: \"%@\";font-size: %gpx;color: black; word-wrap: break-word;}\
  a    { text-decoration:none; color:rgba(35,110,216,1); font-weight:bold;}\
  </style>\
  </head><body style=\"margin:0\">\
  %@\
  </body></html>";
  return [NSString stringWithFormat:embedHTML, [self bgColor], fontName, size, theText];
}

- (NSString*) bgColor
{
  CGColorRef cgColor = _backgroundColor.CGColor;
  const CGFloat *components = CGColorGetComponents(cgColor);
  
  return [NSString stringWithFormat:@"%i, %i, %i, %i", (int)(components[0]*255), (int)(components[1]*255), (int)(components[2]*255), (int)components[3]];
}

#pragma mark -
#pragma mark Regex

- (NSString *)linkRegex
{
  return @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
}

- (NSString *)twitterRegex
{
  return @"@{1}([-A-Za-z0-9_]{2,})";
}

- (NSString *)hashtagRegex
{
  return @"[\\s]{1,}#{1}([^\\s]{2,})";
}

#pragma mark -
#pragma mark Dealloc

- (void) dealloc
{
  [_text release]; 
  [_font release]; 
  [_aWebView release];
  [super dealloc];
}

@end