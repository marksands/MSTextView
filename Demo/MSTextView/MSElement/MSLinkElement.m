//
//  MSLinkElement.m
//  UITextViewLinkOptions
//
//  Created by Mark Sands on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MSLinkElement.h"


#define kHighlightColor [UIColor colorWithRed:172.0/255.0 green:200.0/255.0 blue:236.0/255.0 alpha:0.25];

#define kScreenViewFrame CGRectMake(self.bounds.origin.x-1, self.bounds.origin.y-2, self.bounds.size.width+2, self.bounds.size.height+4)

@implementation MSLinkElement

@synthesize URL = _URL;
@synthesize delegate;
@synthesize _screenView;

- (id) initWithFrame:(CGRect)frame
{
  if ( (self = [super initWithFrame:frame]) ) {
    [self addTarget:self
             action:@selector(handleURL:) 
   forControlEvents:UIControlEventTouchUpInside];
  }

  return self;
}

- (id) initWithFrame:(CGRect)frame andURL:(NSURL *)URL
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
  if (self.delegate != nil && [self.delegate respondsToSelector:@selector(handleURL:)]) {
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

  if (highlighted) {
    if (!_screenView) {
      _screenView = [[UIView alloc] initWithFrame:kScreenViewFrame];
      _screenView.backgroundColor = kHighlightColor;
      _screenView.userInteractionEnabled = NO;
      
      CALayer *round = [_screenView layer];
      round.masksToBounds = YES;
      round.cornerRadius = 2.0;
      round.borderWidth = 0.0;
      
      [self addSubview:_screenView];
    }

    _screenView.frame = kScreenViewFrame;
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

  if (_screenView) {
    [_screenView release];
    _screenView = nil;
  }

  [super dealloc];
}

@end
