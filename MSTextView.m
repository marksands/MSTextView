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

- (id) initWithText:(NSString*)text andFrame:(CGRect)frame
{
  if ( (self=[super initWithFrame:frame]) ) {
    _text = [text retain];
    _Parser = [[MSParser alloc] initWithParseText:_text];    

    // clear by default, the user can change at his/her request
    self.backgroundColor = [UIColor clearColor];
  }

  return self;
}

- (void) setText:(NSString *)txt
{
  _text = [txt retain];
}

#pragma mark -
#pragma mark UILabel

- (void) layoutSubviews
{
  int i = self.bounds.origin.y;
  MSNode *cur = _Parser.root;

  while ( cur != nil )  
  {
    UILabel *lbl = [[UILabel alloc] init];
    lbl.backgroundColor = [UIColor clearColor];

    if ([cur isKindOfClass:[MSTextNode class]]) {
      lbl.text = [(MSTextNode*)cur Text];
      lbl.font = [UIFont systemFontOfSize:16.0];
      lbl.textColor = [UIColor blackColor];

      lbl.frame = CGRectMake(self.bounds.origin.x, i, [self sizeOfWidthFromText:lbl.text], [self sizeOfHeightFromText:lbl.text]);
      [self addSubview:lbl];

      i += [self sizeOfHeightFromText:lbl.text];
    }
    else if ([cur isKindOfClass:[MSLinkNode class]]) {
      lbl.text = [(MSLinkNode*)cur URL];
      lbl.font = [UIFont boldSystemFontOfSize:16.0];
      lbl.textColor = kLinkColor;

      lbl.frame = CGRectMake(self.bounds.origin.x, i, [self sizeOfWidthFromBoldText:lbl.text], [self sizeOfHeightFromBoldText:lbl.text]);
      [self addSubview:lbl];

      i += [self sizeOfHeightFromBoldText:lbl.text];

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
