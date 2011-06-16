//
//  MSLinkElement.m
//  UITextViewLinkOptions
//
//  Created by Mark Sands on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MSLinkElement.h"

#define RGBAColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:255.0 alpha:a];
#define RGBColor(r,g,b) RGBAColor(r,g,b,1)

#define kHighlightColor RGBAColor(172.0,200.0,236.0,0.25)

#define kScreenViewFrame CGRectMake(self.bounds.origin.x-1, self.bounds.origin.y-2, self.bounds.size.width+2, self.bounds.size.height+4)

@implementation MSLinkElement

@synthesize URL = _URL;
@synthesize delegate;
@synthesize screenView = _screenView;

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

- (void)didSelectURL
{
  if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didSelectURL:)]) {
    [self.delegate didSelectURL:self.URL];
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
    [self didSelectURL];
  }
}

- (void)setHighlighted:(BOOL)highlighted
{
  [super setHighlighted:highlighted];

  if (highlighted) {
    if (!_screenView) {
      self.screenView = [[UIView alloc] initWithFrame:kScreenViewFrame];
      self.screenView.backgroundColor = kHighlightColor;
      self.screenView.userInteractionEnabled = NO;
      
      CALayer *round = [_screenView layer];
      round.masksToBounds = YES;
      round.cornerRadius = 2.0;
      round.borderWidth = 0.0;
      
      [self addSubview:self.screenView];
    }

    self.screenView.frame = kScreenViewFrame;
    self.screenView.hidden = NO;
    
  } else {
    self.screenView.hidden = YES;
    [self.screenView release];
    self.screenView = nil;
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
