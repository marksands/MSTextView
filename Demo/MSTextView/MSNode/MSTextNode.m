//
//  MSTextNode.m
//  UITextViewLinkOptions
//
//  Created by Mark Sands on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSTextNode.h"

@implementation MSTextNode

@synthesize Text = _Text;

+ (id) textNodeWithText:(NSString *)text
{
  if ( (self = [[[MSTextNode alloc] initWithText:text next:nil] autorelease]) ){
  }
  
  return self;
}

- (id) initWithText:(NSString *)text
{
  if ( (self = [self initWithText:text next:nil]) ){
  }
  
  return self;
}

- (id) initWithText:(NSString *)text next:(MSNode*)nextNode
{
  if ( (self = [super init]) ){
    self.Text = text;
    self.child = nextNode;
  }
  
  return self;
}

- (NSString*)description {
  return self.Text; 
}

- (void) dealloc
{
  [_Text release];
  [super dealloc];
}

@end
