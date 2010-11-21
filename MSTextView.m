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

#import "MSFrame.h"
#import "MSParser.h"

@implementation MSTextView

@synthesize text   = _text;
@synthesize Frame  = _Frame;
@synthesize Parser = _Parser;

@synthesize delegate;

- (id) initWithText:(NSString*)text andFrame:(CGRect)frame
{
  if ( (self=[super initWithFrame:frame]) ) {
    _text = [text retain];
    
    _Parser = [[MSParser alloc] initWithParseText:_text];
    
    _Frame  = [[MSFrame alloc] initWithRootNode:_Parser.root];    
    
    //self.backgroundColor = [UIColor clearColor];
    
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
  int i = 240;
  MSNode *cur = _Parser.root;
  
  while ( cur != nil )  
  {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(160, i, 320, 28)];
    lbl.backgroundColor = [UIColor clearColor];

    if ([cur isKindOfClass:[MSTextNode class]]) {
      lbl.text = [(MSTextNode*)cur Text];
      lbl.font = [UIFont systemFontOfSize:16.0];
      lbl.textColor = [UIColor blackColor];
      
      lbl.frame = CGRectMake(160, i, 300, [self sizeOfHeightFromText:lbl.text]);

      [self addSubview:lbl];

      i += [self sizeOfHeightFromText:lbl.text];
    }
    else if ([cur isKindOfClass:[MSLinkNode class]]) {
      lbl.text = [(MSLinkNode*)cur URL];
      lbl.font = [UIFont boldSystemFontOfSize:16.0];
      lbl.textColor = [UIColor blueColor];

      lbl.frame = CGRectMake(160, i, 300, [self sizeOfHeightFromBoldText:lbl.text]);
      [lbl sizeToFit];
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

- (void) linkTouched:(NSString*)url
{
  NSLog(@"middle link: %@",url);
  
  if ([(NSObject*)self.delegate respondsToSelector:@selector(linkTouched:)]) {
    [self.delegate linkTouched:url];
  }
}

#pragma mark -
#pragma mark UIResponder

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
  //UITouch* touch = [touches anyObject];
  //CGPoint point = [touch locationInView:self];

  //UIView *hitView = [super hitTest:point withEvent:event];
  //return (hitView == self) ? nil : hitView;

  /*
  MSFrame *frame = [_text hitTest:point];
  if (frame) {
    [self setHighlightedFrame:frame];
  }
  */
  
  /*
  BOOL inButton = [theButton pointInside:[self convertPoint:point toView:theButton] withEvent:nil];
	
	if(inButton) {
		UIView *theButtonView = [theButton hitTest:[self convertPoint:point toView:theButton] withEvent:event];
		return theButtonView;
	}
	else {
		return [super hitTest:point withEvent:event];
	}
  */

  
  [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
  [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
  /*
  if ([_highlightedNode isKindOfClass:[TTStyledLinkNode class]]) {
    TTOpenURL([(TTStyledLinkNode*)_highlightedNode URL]);
  */
  
  [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
  [super touchesCancelled:touches withEvent:event];
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
  [_Frame release];
  [_Parser release];
  [super dealloc];
}

@end
