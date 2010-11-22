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

@synthesize root = _root;

- (id) init
{
  if ( (self = [super init]) ) {
  }
  return self;
}

- (id) initWithParseText:(NSString*)text
{
  if ( (self=[super init]) ) {
    [self parseURLs:text];
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

// modified from three20 https://github.com/facebook/three20/blob/master/src/Three20Style/Sources/TTStyledTextParser.m#L112-155
- (void)parseURLs:(NSString*)string
{
  // prevent chaining of urls by newline character. This should really be improved :/
  NSString *temp = [string stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
  string = temp;

  NSInteger stringIndex = 0;

  while (stringIndex < string.length) {
    NSRange searchRange = NSMakeRange(stringIndex, string.length - stringIndex);
    NSRange startRange = [string rangeOfString:@"http://" 
                                       options:NSCaseInsensitiveSearch
                                         range:searchRange];
    if (startRange.location == NSNotFound) {
      NSString *text = [string substringWithRange:searchRange];
      NSArray *splitChars = [text componentsSeparatedByString:@" "];
      for ( id obj in splitChars ) {
        NSString *temp = [obj stringByAppendingString:@" "];
        MSTextNode *node = [[[MSTextNode alloc] initWithText:temp] autorelease];
        [self addNode:node];  
      }

      break;
    }
    else {
      NSRange beforeRange = NSMakeRange(searchRange.location, startRange.location - searchRange.location);
      if (beforeRange.length) {
        NSString *text = [string substringWithRange:beforeRange];
        NSArray *splitChars = [text componentsSeparatedByString:@" "];
        // skip the final space/@" " node
        for (int i = 0; i < [splitChars count]-1; i++) {
          NSString *temp = [[splitChars objectAtIndex:i] stringByAppendingString:@" "];
          MSTextNode *node = [[[MSTextNode alloc] initWithText:temp] autorelease];
          [self addNode:node]; 
        }      
      }

      NSRange subSearchRange = NSMakeRange(startRange.location, string.length - startRange.location);
      NSRange endRange = [string rangeOfString:@" " 
                                       options:NSCaseInsensitiveSearch
                                         range:subSearchRange];
      if (endRange.location == NSNotFound) {
        NSString *URL = [string substringWithRange:subSearchRange];
        MSLinkNode *node = [[(MSLinkNode*)[MSLinkNode alloc] initWithURL:URL] autorelease];
        [self addNode:node];
        break;  
      }
      else {
        NSRange URLRange = NSMakeRange(startRange.location, endRange.location - startRange.location);
        NSString *URL = [string substringWithRange:URLRange];
        MSLinkNode *node = [[(MSLinkNode*)[MSLinkNode alloc] initWithURL:URL] autorelease];
        [self addNode:node];
        stringIndex = endRange.location;
      }
    }
  }
}

- (void) dealloc
{
  [_root release];
  [super dealloc];
}

@end
