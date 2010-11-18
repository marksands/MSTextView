//
//  MSTextView.m
//  UITextViewLinkOptions
//
//  Created by Mark Sands on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSTextView.h"

#import "MSFrame.h"
#import "MSParser.h"

@implementation MSTextView

@synthesize text   = _text;
@synthesize Frame  = _Frame;
@synthesize Parser = _Parser;

- (id) initWithText:(NSString*)text
{
  if ( (self=[super init]) ) {
    _text = [text retain];

    _Parser = [[MSParser alloc] initWithParseText:_text];
    
    _Frame  = [[MSFrame alloc] initWithRootNode:_Parser.root];
  }
  
  return self;
}

- (void) dealloc {
  [_Frame release];
  [_Parser release];
  [super dealloc];
}

@end
