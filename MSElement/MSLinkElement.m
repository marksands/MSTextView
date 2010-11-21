//
//  MSLinkElement.m
//  UITextViewLinkOptions
//
//  Created by Mark Sands on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MSLinkElement.h"

#define kHighlightColor [UIColor colorWithRed:0.2 green:0.4 blue:0.8 alpha:0.10] 

@implementation MSLinkElement

@synthesize URL = _URL;
@synthesize delegate;

- (id) initWithFrame:(CGRect)frame
{
  if ( (self = [super initWithFrame:frame]) ) {
    [self addTarget:self
             action:@selector(handleURL:) 
   forControlEvents:UIControlEventTouchUpInside];
  }

  return self;
}

- (id) initWithFrame:(CGRect)frame andURL:(NSString*)URL
{
  if ( (self = [self initWithFrame:frame]) ) {
    _URL = URL;
    self.backgroundColor = [UIColor clearColor];
  }

  return self;
}

#pragma mark -
#pragma mark Delegate

- (void)handleURL
{
  if ([(NSObject*)self.delegate respondsToSelector:@selector(handleURL:)]) {
    [self.delegate handleURL:self.URL];
  }
}

#pragma mark -
#pragma mark UIControl

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  self.highlighted = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  self.highlighted = NO;
  
  UITouch *touch = [touches anyObject];
  if ([self pointInside:[touch locationInView:self] withEvent:event]) {
    [self handleURL];
  }
}

- (void)setHighlighted:(BOOL)highlighted
{
  [super setHighlighted:highlighted];
  
  static UIView* _screenView;
  
  if (highlighted) {
    if (!_screenView) {
      _screenView = [[UIView alloc] initWithFrame:self.bounds];
      _screenView.backgroundColor = kHighlightColor;
      _screenView.userInteractionEnabled = NO;
      
      CALayer *round = [_screenView layer];
      round.masksToBounds = YES;
      round.cornerRadius = 3.0;
      round.borderWidth = 0.0;
      
      [self addSubview:_screenView];
    }

    _screenView.frame = self.bounds;
    _screenView.hidden = NO;
    
  } else {
    _screenView.hidden = YES;
    [_screenView release];
    _screenView = nil;
  }

}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
  if ([self pointInside:[touch locationInView:self] withEvent:event]) {
    return YES;
  }
  else {
    self.highlighted = NO;
    return NO;
  }
}

#pragma mark -

- (void) dealloc
{
  [_URL release];
  [super dealloc];
}

@end
