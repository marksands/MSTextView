//
//  MSLinkNode.h
//  UITextViewLinkOptions
//
//  Created by Mark Sands on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSNode.h"

@interface MSLinkNode : MSNode {
  NSURL *_URL;
}

@property (nonatomic, retain) NSURL *URL;

- (id) initWithURL:(NSURL*)url;
- (id) initWithURL:(NSURL*)url next:(MSNode*)nextNode;

@end
