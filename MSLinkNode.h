//
//  MSLinkNode.h
//  UITextViewLinkOptions
//
//  Created by Mark Sands on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSNode.h"

@interface MSLinkNode : MSNode {
  NSString* _URL;
}

@property (nonatomic, retain) NSString* URL;

- (id) initWithURL:(NSString*)url;
- (id) initWithURL:(NSString*)url next:(MSNode*)nextNode;

@end
