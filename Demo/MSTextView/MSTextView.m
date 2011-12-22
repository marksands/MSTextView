//
//  WBTextView.m
//  MSTextView
//
//  Created by Mark Sands on 12/4/10.
//  Copyright 2010 Mark Sands. All rights reserved.
//

#import "MSTextView.h"

#define kMSTextViewFont [UIFont fontWithName:@"Helvetica" size:20]

static char *KVOMSTextViewTextDidChange = "KVOMSTViewTextDidChange";
static char *KVOMSTextViewFrameDidChange = "KVOMSTextViewFrameDidChange";

@interface MSTextView (PrivateMethods)
- (void)       parseText;
- (NSString *) linkRegex;
- (CGFloat)    fontSize;
- (NSString *) fontName;
- (NSString *) embedHTMLWithFontName:(NSString *)fontName
                                size:(CGFloat)size
                                text:(NSString *)theText;
@end

@implementation MSTextView

@synthesize text = _text;
@synthesize font = _font;
@synthesize aWebView = _aWebView;
@synthesize delegate;

#pragma mark -
#pragma mark MSTextView

- (id)init
{
  if ((self = [self initWithFrame:CGRectZero]))
  {

  }

  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame]))
  {
    self.aWebView = [[UIWebView alloc] initWithFrame:self.bounds];
    self.aWebView.opaque = NO;
    self.aWebView.backgroundColor = [UIColor clearColor];
    self.aWebView.delegate = self;
    [self addSubview:self.aWebView];

    self.font = kMSTextViewFont;

    for (id subview in self.aWebView.subviews)
    {
      // turn off scrolling in UIWebView
      if ([[subview class] isSubclassOfClass:[UIScrollView class]]) {
        ((UIScrollView *)subview).bounces = NO;
        ((UIScrollView *)subview).scrollEnabled = NO;
      }

      // make UIWebView transparent
      if ([subview isKindOfClass:[UIImageView class]])
        ((UIImageView *)subview).hidden = YES;
      }

    /*! Using Key-Value Observing/KVO to parse text after changing it */
    [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:KVOMSTextViewTextDidChange];

    /*! Using Key-Value Observing/KVO to change aWebView frame after changing MSTextView's frame */
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:KVOMSTextViewFrameDidChange];
  }

  return self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  if( navigationType == UIWebViewNavigationTypeLinkClicked )
  {
    if ([self.delegate respondsToSelector:@selector(handleURL:)]) {
      [self.delegate handleURL:request.URL];
    }

    return NO;
  }

  return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  CGRect frame = webView.frame;
  frame.size.height = 1;
  webView.frame = frame;

  CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
  frame.size = fittingSize;
  webView.frame = frame;

  if (self.frame.size.height < webView.frame.size.height)
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, webView.frame.size.height);
}

#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if ([keyPath isEqualToString:@"text"])
    [self parseText];
  else if ([keyPath isEqualToString:@"frame"])
    [self.aWebView setFrame:self.bounds];
}

#pragma mark -
#pragma mark Text Parsing

- (void)parseText
{
  NSMutableString *theText = [NSMutableString stringWithString:_text];

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

  [theText replaceOccurrencesOfString:@"\n" withString:@"<br />" options:NSLiteralSearch range:NSMakeRange(0, theText.length)];

  [self.aWebView loadHTMLString:[self embedHTMLWithFontName:[self fontName]
                                                   size:[self fontSize]
                                                   text:theText]
                    baseURL:nil];
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
#pragma mark embedHTML

- (NSString *) embedHTMLWithFontName:(NSString *)fontName
                                size:(CGFloat)size
                                text:(NSString *)theText
{
  NSString *embedHTML = @"\
  <html><head>\
  <style type=\"text/css\">\
  body { background-color:transparent;font-family: \"%@\";font-size: %gpx;color: black; word-wrap: break-word;}\
  a    { text-decoration:none; color:rgba(35,110,216,1); font-weight:bold;}\
  </style>\
  </head><body style=\"margin:0\">\
  %@\
  </body></html>";
  return [NSString stringWithFormat:embedHTML, fontName, size, theText];
}

#pragma mark -
#pragma mark Regex

- (NSString *)linkRegex
{
  return @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
}

#pragma mark -
#pragma mark Dealloc

- (void) dealloc
{
  [_text release];
  [_font release];
  [_aWebView release];

  [self removeObserver:self forKeyPath:@"text"];

  [super dealloc];
}

@end