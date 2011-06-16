//
//  MSTextNode.h
//  UITextViewLinkOptions
//
//  Created by Mark Sands on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSNode.h"

@interface MSTextNode : MSNode {
  NSString *_Text;
}

@property (nonatomic, retain) NSString *Text;

+ (id)textNodeWithText:(NSString *)text;

- (id)initWithText:(NSString *)text;
- (id)initWithText:(NSString *)text next:(MSNode*)nextNode;

@end