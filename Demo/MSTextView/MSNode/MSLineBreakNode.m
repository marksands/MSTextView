//
//  MSLineBreakNode.m
//  UITextViewLinkOptions
//
//  Created by Mark Sands on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSLineBreakNode.h"

@implementation MSLineBreakNode

- (id) initWithNextNode:(MSNode*)nextNode
{
  if ( (self = [super init]) ){
    self.child = nextNode;
  }
  
  return self;
}

- (NSString*)description {
  return @"\\n";
}

- (void) dealloc
{
  [super dealloc];
}

@end
