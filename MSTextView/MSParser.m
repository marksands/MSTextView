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
#import "MSLineBreakNode.h"

@implementation  MSParser

@synthesize root = _root;

- (id) init
{
  if ( (self = [super init]) ) {
  }
  return self;
}

- (id) initWithParseText:(NSString *)text
{
  if ( (self=[super init]) ) {
    [self parseURLs:text];
  }

  return self;
}

- (void)addNode:(MSNode *)node
{
  if (!_root) {
    _root = [node retain];
    _tail = node;
  }
  else {
    node.parent = _tail;
    _tail.child = node;
    _tail = node;
  }
}

// modified from three20 https://github.com/facebook/three20/blob/master/src/Three20Style/Sources/TTStyledTextParser.m#L112-155
- (void)parseURLs:(NSString *)string
{
  NSInteger stringIndex = 0;

  while (stringIndex < string.length) {
    NSRange searchRange = NSMakeRange(stringIndex, string.length - stringIndex);
    NSRange startRange = [string rangeOfString:@"http://" 
                                       options:NSCaseInsensitiveSearch
                                         range:searchRange];
    if (startRange.location == NSNotFound) {
      NSString *text = [string substringWithRange:searchRange];
      NSArray *splitChars = [text componentsSeparatedByString:@" "];
      for ( id obj in splitChars) {
        NSString *temp = [obj stringByAppendingString:@" "];
        MSTextNode *node = [MSTextNode textNodeWithText:temp];
        [self addNode:node]; 
      }

      break;
    }
    else {
      NSRange beforeRange = NSMakeRange(searchRange.location, startRange.location - searchRange.location);
      if (beforeRange.length) {
        NSString *text = [string substringWithRange:beforeRange];
        NSArray *splitChars = [text componentsSeparatedByString:@" "];
        for ( id obj in splitChars) {
          NSString *temp = [obj stringByAppendingString:@" "];
          MSTextNode *node = [MSTextNode textNodeWithText:temp];
          [self addNode:node];             
        }
      }

      NSRange subSearchRange = NSMakeRange(startRange.location, string.length - startRange.location);
      NSRange endRange = [string rangeOfString:@" " 
                                       options:NSCaseInsensitiveSearch
                                         range:subSearchRange];      
      if (endRange.location == NSNotFound) {
        NSURL *URL = [NSURL URLWithString:[string substringWithRange:subSearchRange]];
        MSLinkNode *node = [MSLinkNode linkNodeWithURL:URL];
        [self addNode:node];
        break;  
      }
      else {
        NSRange URLRange = NSMakeRange(startRange.location, endRange.location - startRange.location);
        NSURL *URL = [NSURL URLWithString:[string substringWithRange:URLRange]];
        MSLinkNode *node = [MSLinkNode linkNodeWithURL:URL];
        [self addNode:node];
        stringIndex = endRange.location;
      }
    }
  }

  [self splitNodesOnLineBreak];
  [self cleanWhiteSpace];
}

- (void) cleanWhiteSpace
{
  MSNode *cur = _root;
  while ( cur != nil ) {
    if ([cur isMemberOfClass:[MSTextNode class]] && [[(MSTextNode*)cur Text] isEqualToString:@" "] && [cur.child isMemberOfClass:[MSLinkNode class]]) {
      cur.parent.child = cur.child;
      cur.child.parent = cur.parent;
    }
    cur = cur.child;
  }
  
  cur = _tail;  
    // remove trailing space at end of text
  if ([cur isMemberOfClass:[MSTextNode class]]) {
    [(MSTextNode*)cur setText:[[(MSTextNode*)cur Text] stringByReplacingOccurrencesOfString:@" " withString:@""]];
  }
}

- (void) splitNodesOnLineBreak
{
  MSNode *cur = _root;
  while ( cur != nil )
  {
    MSNode *btm = cur.child;
    MSNode *top;

    if (cur == _root) {
      top = _root;
    }
    else {
      top = cur.parent;
    }
    
    if ([cur isMemberOfClass:[MSTextNode class]]) {

      NSArray *splitText = [[(MSTextNode*)cur Text] componentsSeparatedByString:@"\n"];
      if ([splitText count] > 1) {
        for (NSString* obj in splitText)
        {
          MSNode *node;
          NSRange isURL = [obj rangeOfString:@"http://" options:NSCaseInsensitiveSearch range:NSMakeRange(0, obj.length)];
          if (isURL.location == NSNotFound) {
            node = [[[MSTextNode alloc] initWithText:obj] autorelease];          
          }
          else {
            node = [[[MSLinkNode alloc] initWithURL:[NSURL URLWithString:obj]] autorelease];
          }

          if (cur == _root) {
            [_root release];
            _root = [node retain];
          } else {
            node.parent = top;
            top.child   = node;
          }

          // don't add \n to end of array
          if (obj != [splitText lastObject]) {
            MSLineBreakNode *lbnode = [[(MSLineBreakNode*)[MSLineBreakNode alloc] init] autorelease];
            lbnode.parent = node;
            node.child = lbnode;            
            
            cur = lbnode;
          }
          else {
            cur = node;
          }
          
          top = cur;
        }
        cur.child = btm;
        btm.parent = cur;
      }
    }
    else if ([cur isMemberOfClass:[MSLinkNode class]]) {
      
      NSArray *splitLink = [[NSString stringWithFormat:@"%@",[(MSLinkNode*)cur URL]] componentsSeparatedByString:@"\n"];      
      if ([splitLink count] > 1) {
        for (NSString* obj in splitLink)
        {
          MSNode *node;
          NSRange isURL = [obj rangeOfString:@"http://" options:NSCaseInsensitiveSearch range:NSMakeRange(0, obj.length)];
          if (isURL.location == NSNotFound) {
            node = [[[MSTextNode alloc] initWithText:obj] autorelease];          
          }
          else {
            node = [[[MSLinkNode alloc] initWithURL:[NSURL URLWithString:obj]] autorelease];
          }

          if (cur == _root) {
            [_root release];
            _root = [node retain];
          } else {
            node.parent = top;
            top.child   = node;
          }

          // don't add \n to end of array
          if (obj != [splitLink lastObject]) {
            MSLineBreakNode *lbnode = [[(MSLineBreakNode*)[MSLineBreakNode alloc] init] autorelease];
            lbnode.parent = node;
            node.child = lbnode;            
        
            cur = lbnode;
          }
          else {
            cur = node;
          }          
          
          top = cur;
        }
        cur.child = btm;
        btm.parent = cur;
      }
    }

    cur = cur.child;

  }
}

- (void) dealloc
{
  [_root release];
  [super dealloc];
}

@end
