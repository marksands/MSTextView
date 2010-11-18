//
//  MSNSString.m
//  UITextViewLinkOptions
//
//  Created by Mark Sands on 11/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSParser.h"

#import "MSNode.h"
#import "MSTextNode.h"
#import "MSLinkNode.h"

@implementation  MSParser

@synthesize root = _root;;

- (id) init
{
  if ( (self = [super init]) ) {
  }
  return self;
}

- (void)addNode:(MSNode*)node
{
  if (!_root) {
    _root = [node retain];
    _tail = node;
  }
  else {
    _tail.child = node;
    _tail = node;
  }
}

// three20
- (void)parseURLs:(NSString*)string
{
  NSInteger stringIndex = 0;
  
  while (stringIndex < string.length) {
    NSRange searchRange = NSMakeRange(stringIndex, string.length - stringIndex);
    NSRange startRange = [string rangeOfString:@"http://" 
                                       options:NSCaseInsensitiveSearch
                                         range:searchRange];
    if (startRange.location == NSNotFound) {
      NSString* text = [string substringWithRange:searchRange];
      MSTextNode* node = [[[MSTextNode alloc] initWithText:text] autorelease];
      [self addNode:node];
      break;

    }
    else {
      NSRange beforeRange = NSMakeRange(searchRange.location, startRange.location - searchRange.location);
      if (beforeRange.length) {
        NSString* text = [string substringWithRange:beforeRange];
        MSTextNode* node = [[[MSTextNode alloc] initWithText:text] autorelease];
        [self addNode:node];
      }

      NSRange subSearchRange = NSMakeRange(startRange.location, string.length - startRange.location);
      NSRange endRange = [string rangeOfString:@" " 
                                       options:NSCaseInsensitiveSearch
                                         range:subSearchRange];
      if (endRange.location == NSNotFound) {
        NSString* URL = [string substringWithRange:subSearchRange];
        MSLinkNode* node = [[[MSLinkNode alloc] initWithURL:URL] autorelease];
        [self addNode:node];
        break;  
      }
      else {
        NSRange URLRange = NSMakeRange(startRange.location, endRange.location - startRange.location);
        NSString* URL = [string substringWithRange:URLRange];
        MSLinkNode* node = [[[MSLinkNode alloc] initWithURL:URL] autorelease];
        [self addNode:node];
        stringIndex = endRange.location;
      }
    }
  }
}

- (void) dealloc
{
  
  NSLog(@"root: %@", [self.root description]);
  
  MSNode *node = self.root;
  while (node != nil) {
    NSLog(@"%@",[node description]);
    node = node.child;
  }
  NSLog(@"tail: %@", [_tail description]);
  
  [_root release];
  [super dealloc];
}

@end
