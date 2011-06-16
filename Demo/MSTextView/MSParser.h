//
//  MSNSString.h
//  UITextViewLinkOptions
//
//  Created by Mark Sands on 11/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MSNode;

@interface MSParser : NSObject {
  MSNode *_root;
  MSNode *_tail;
}

@property (nonatomic, retain) MSNode *root;

- (id)initWithParseText:(NSString *)text;

- (void)addNode:(MSNode *)node;
- (void)parseURLs:(NSString *)string;

- (void)splitNodesOnLineBreak;
- (void)cleanWhiteSpace;

@end
