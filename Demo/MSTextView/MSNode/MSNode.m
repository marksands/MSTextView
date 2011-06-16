//
//  MSNode.m
//  UITextViewLinkOptions
//
//  Created by Mark Sands on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSNode.h"

@implementation MSNode

@synthesize parent = _parent;;
@synthesize child = _child;

- (id)initWithChild:(MSNode *)childNode {
  if ((self = [super init])) {
    self.child = childNode;
  }
  
  return self;
}

- (id)init {
  if ((self = [self initWithChild:nil])){
  }
  
  return self;
}

- (void)dealloc
{
  [_child release];
  [super dealloc];
}

@end
