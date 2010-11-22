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

#import "MSParser.h"

#define kLinkColor [UIColor colorWithRed:0.1 green:0.1 blue:1 alpha:1] 

@implementation MSTextView

@synthesize text   = _text;
@synthesize Parser = _Parser;

@synthesize delegate;

- (id) init
{
  if ( (self=[super init]) ) {
    // clear by default, the user can change at his/her request
    self.backgroundColor = [UIColor clearColor];    
  }

  return self;
}

- (id) initWithFrame:(CGRect)frame
{
  if ( (self=[super initWithFrame:frame]) ) {
    // clear by default, the user can change at his/her request
    self.backgroundColor = [UIColor clearColor];    
  }

  return self;
}

- (id) initWithText:(NSString*)text andFrame:(CGRect)frame
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

// need curY to update globally where the y coordinate is at on each line
// the localHeight will tell us how high the line should be. sizeOfHeightFromText or sizeOfHeightFromBoldText. needs to reset on newline.
// curX will tell us where we are relative to self.bounds curX makes sure the sum of all nodes on the current line is < self.bounds.size.width

- (void) layoutSubviews
{
  CGFloat curY = self.bounds.origin.y;
  CGFloat curX = self.bounds.origin.x;
  CGFloat localHeight = curY;

  MSNode *cur = _Parser.root;

  while ( cur != nil )  
  {
    UILabel *lbl = [[UILabel alloc] init];
    lbl.backgroundColor = [UIColor clearColor];

    if ([cur isKindOfClass:[MSTextNode class]]) {
      lbl.text = [(MSTextNode*)cur Text];
      lbl.font = [UIFont systemFontOfSize:16.0];
      lbl.textColor = [UIColor blackColor];

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
      lbl.text = [(MSLinkNode*)cur URL];
      lbl.font = [UIFont boldSystemFontOfSize:16.0];
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

      [self addSubview:lbl];

      MSLinkElement *el = [[MSLinkElement alloc] initWithFrame:lbl.frame andURL:lbl.text];
      el.delegate = self;
      el.backgroundColor = [UIColor clearColor];
      [self addSubview:el];
      [el release];
    }

    cur = cur.child;    
    [lbl release];
  }
}

- (CGFloat)sizeOfHeightFromText:(NSString*)theText
{
  UIFont *font = [UIFont systemFontOfSize:16.0];
  // numberOfLines = ceilf([theText sizeWithFont:font] constrainedToSize:[CGSizeMake(300, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap].height/20.0);

  CGSize size = [theText sizeWithFont:font constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
  return size.height;
}

- (CGFloat)sizeOfHeightFromBoldText:(NSString*)theText
{
  UIFont *font = [UIFont boldSystemFontOfSize:16.0];
  // numberOfLines = ceilf([theText sizeWithFont:font] constrainedToSize:[CGSizeMake(300, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap].height/20.0);

  CGSize size = [theText sizeWithFont:font constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
  return size.height;
}

- (CGFloat)sizeOfWidthFromText:(NSString*)theText
{
  UIFont *font = [UIFont systemFontOfSize:16.0];
  CGSize sizeToMakeLabel = [theText sizeWithFont:font]; 
  
  return sizeToMakeLabel.width;
}

- (CGFloat)sizeOfWidthFromBoldText:(NSString*)theText
{
  UIFont *font = [UIFont boldSystemFontOfSize:16.0];
  CGSize sizeToMakeLabel = [theText sizeWithFont:font]; 
  
  return sizeToMakeLabel.width;
}

- (BOOL)nodesExceedFrameWidthForSum:(CGFloat)sum
{
  if (sum >= self.bounds.size.width)
    return YES;
  return NO;
}


#pragma mark -
#pragma mark Delegate

- (void) handleURL:(NSString*)url
{  
  if ([(NSObject*)self.delegate respondsToSelector:@selector(handleURL:)]) {
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
  [super dealloc];
}

@end
