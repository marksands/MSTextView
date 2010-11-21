//
//  MSTextView.h
//  UITextViewLinkOptions
//
//  Created by Mark Sands on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MSLinkElement.h"
#import "MSTextElement.h"

@class MSNode;
@class MSFrame;
@class MSParser;

@protocol MSTextViewDelegate
- (void) handleURL:(NSString*)url;
@end


@interface MSTextView : UIView <MSLinkDelegate> {
  NSString *_text;
  
  MSParser *_Parser;
  
  MSNode *_first;
  MSNode *_tail;

  id<MSTextViewDelegate> delegate;
}

@property (nonatomic, assign) id<MSTextViewDelegate> delegate;
@property (nonatomic, assign) NSString *text;

@property (nonatomic, retain) MSParser *Parser;

- (id) initWithText:(NSString*)text andFrame:(CGRect)frame;

- (CGFloat)sizeOfHeightFromText:(NSString*)theText;
- (CGFloat)sizeOfHeightFromBoldText:(NSString*)theText;

- (CGFloat)sizeOfWidthFromText:(NSString*)theText;
- (CGFloat)sizeOfWidthFromBoldText:(NSString*)theText;

@end
