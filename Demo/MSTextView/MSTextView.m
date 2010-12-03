//
//  MSTextView.m
//  UITextViewLinkOptions
//
//  Created by Mark Sands on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSTextView.h"

#import "MSTextNode.h"
#import "MSLinkNode.h"
#import "MSLineBreakNode.h"

#import "MSParser.h"

#define kLinkColor [UIColor colorWithRed:35.0/255.0 green:110.0/255.0 blue:216.0/255.0 alpha:1]
#define kLinkFont  [UIFont fontWithName:@"Helvetica-Bold" size:20.0]

#define kDefaultFont [UIFont fontWithName:@"Helvetica" size:20.0]
#define kDefaultTextColor [UIColor blackColor]

@implementation MSTextView

@synthesize Parser    = _Parser;
@synthesize text      = _text;
@synthesize font      = _font;
@synthesize linkFont  = _linkFont;
@synthesize textColor = _textColor;

@synthesize delegate;

- (id) init
{
  if ( (self=[super init]) ) {
    self.backgroundColor = [UIColor clearColor];
    _font = kDefaultFont;
    _linkFont = kLinkFont;
    _textColor = kDefaultTextColor;
  }

  return self;
}

- (id) initWithFrame:(CGRect)frame
{
  if ( (self=[super initWithFrame:frame]) ) {
    self.backgroundColor = [UIColor clearColor];
    _font = kDefaultFont;
    _linkFont = kLinkFont;
    _textColor = kDefaultTextColor;
  }

  return self;
}

- (id) initWithFrame:(CGRect)frame andText:(NSString *)text
{
  if ( (self=[self initWithFrame:frame]) ) {
    _text   = [text retain];
    _Parser = [[MSParser alloc] initWithParseText:_text];    
  }

  return self;
}

- (void) setText:(NSString *)txt
{
  _text = [txt retain];
  if (!_Parser) {
    _Parser = [[MSParser alloc] initWithParseText:_text];    
  }
}

#pragma mark -
#pragma mark UILabel

- (void) layoutSubviews
{
  CGFloat curY = self.bounds.origin.y;
  CGFloat curX = self.bounds.origin.x;
  CGFloat localHeight = 20.0;

  MSNode *cur = _Parser.root;

  while ( cur != nil )  
  {
    UILabel *lbl = [[UILabel alloc] init];
    lbl.backgroundColor = [UIColor clearColor];

    if ([cur isKindOfClass:[MSTextNode class]]) {
      lbl.text = [(MSTextNode*)cur Text];
      lbl.font = self.font;
      lbl.textColor = self.textColor;

      CGFloat tempSum = curX + [self sizeOfWidthFromText:lbl.text];
      if ([self nodesExceedFrameWidthForSum:tempSum]) {
        curY += localHeight;
        localHeight = [self sizeOfHeightFromText:lbl.text];
        curX = self.bounds.origin.x;
      }
      else {
        localHeight = (localHeight < [self sizeOfHeightFromText:lbl.text]) ? [self sizeOfHeightFromText:lbl.text] : localHeight;
      }

      lbl.frame = CGRectMake(curX, curY, [self sizeOfWidthFromText:lbl.text], [self sizeOfHeightFromText:lbl.text]);
      curX += [self sizeOfWidthFromText:lbl.text];

      [self addSubview:lbl];
    }
    else if ([cur isKindOfClass:[MSLinkNode class]]) {
      lbl.text = [NSString stringWithFormat:@"%@",[(MSLinkNode*)cur URL]];
      lbl.font = _linkFont;
      lbl.textColor = kLinkColor;

      CGFloat tempSum = curX + [self sizeOfWidthFromBoldText:lbl.text];
      if ([self nodesExceedFrameWidthForSum:tempSum]) {
        curY += localHeight;
        localHeight = [self sizeOfHeightFromBoldText:lbl.text];
        curX = self.bounds.origin.x;
      }
      else {
        localHeight = (localHeight < [self sizeOfHeightFromBoldText:lbl.text]) ? [self sizeOfHeightFromBoldText:lbl.text] : localHeight;
      }

      lbl.frame = CGRectMake(curX, curY, [self sizeOfWidthFromBoldText:lbl.text], [self sizeOfHeightFromBoldText:lbl.text]);
      curX += [self sizeOfWidthFromBoldText:lbl.text];

      // links can be long
      lbl.lineBreakMode = UILineBreakModeCharacterWrap;
      lbl.numberOfLines = 0;

      [self addSubview:lbl];

      MSLinkElement *el = [[MSLinkElement alloc] initWithFrame:lbl.frame andURL:[(MSLinkNode*)cur URL]];
      el.delegate = self;
      [self addSubview:el];
      [el release];
    }
    else if ([cur isKindOfClass:[MSLineBreakNode class]]) {
      curX = self.bounds.origin.x;
      curY += localHeight;
    }

    cur = cur.child;    
    [lbl release];
  }
}

- (CGFloat)sizeOfHeightFromText:(NSString *)theText
{
  CGSize size = [theText sizeWithFont:_font constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:UILineBreakModeCharacterWrap];
  return size.height;
}

- (CGFloat)sizeOfHeightFromBoldText:(NSString *)theText
{
  CGSize size = [theText sizeWithFont:_linkFont constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:UILineBreakModeCharacterWrap];
  return size.height;
}

- (CGFloat)sizeOfWidthFromText:(NSString *)theText
{
  CGSize sizeToMakeLabel = [theText sizeWithFont:_font]; 
  return sizeToMakeLabel.width;
}

- (CGFloat)sizeOfWidthFromBoldText:(NSString *)theText
{
  CGSize sizeToMakeLabel = [theText sizeWithFont:_linkFont]; 
  return (sizeToMakeLabel.width > 300) ? 300 : sizeToMakeLabel.width;
}

- (BOOL)nodesExceedFrameWidthForSum:(CGFloat)sum
{
  if (sum >= self.bounds.size.width)
    return YES;
  return NO;
}


#pragma mark -
#pragma mark Delegate

- (void) handleURL:(NSURL *)url
{  
  if ([(NSObject *)self.delegate respondsToSelector:@selector(handleURL:)]) {
    [self.delegate handleURL:url];
  }
}

#pragma mark -
#pragma mark UIView

- (void)drawRect:(CGRect)rect
{
}

- (CGSize)sizeThatFits:(CGSize)size
{
  return size;
}

#pragma mark -

- (void) dealloc {
  [_Parser release];
  [_text release];
  [super dealloc];
}

@end
