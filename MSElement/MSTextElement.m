//
//  MSTextElement.m
//  UITextViewLinkOptions
//
//  Created by Mark Sands on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSTextElement.h"

@implementation MSTextElement

@synthesize text = _text;

- (id) init
{
  if ( (self = [super init]) ) {
    // this class ins't used..yet
  }
  
  return self;
}

#pragma mark -

- (void) dealloc
{
  [_text release];
  [super dealloc];
}

@end
