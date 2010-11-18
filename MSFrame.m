//
//  MSFrame.m
//  UITextViewLinkOptions
//
//  Created by Mark Sands on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSFrame.h"

#import "MSNode.h"

#import "MSElement.h"
#import "MSTextElement.h"
#import "MSLinkElement.h"

@implementation MSFrame

@synthesize root = _root;

- (id) initWithRootNode:(MSNode*)node
{
  if ( (self = [super init]) ) {
    _root = [node retain];
  }

  // sanity check
  MSNode *n = _root;
  while (n != nil) {
    NSLog(@"%@",n);
    n = n.child;
  }
  
  return self;
}

- (void) dealloc
{
  [super dealloc];
}

@end