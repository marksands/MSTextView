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
@class MSParser;

@protocol MSTextViewDelegate
- (void) handleURL:(NSURL*)url;
@end


@interface MSTextView : UIView <MSLinkDelegate> {
  NSString *_text;
  UIFont   *_font;
  UIFont   *_linkFont;
  UIColor  *_textColor;
  
  MSParser *_Parser;
  
  id<MSTextViewDelegate> delegate;
}

@property (nonatomic, assign) id<MSTextViewDelegate> delegate;
@property (nonatomic, retain) MSParser *Parser;

@property (nonatomic, assign) NSString *text;
@property (nonatomic, assign) UIFont   *font;
@property (nonatomic, assign) UIFont   *linkFont;
@property (nonatomic, assign) UIColor  *textColor;

- (id) initWithFrame:(CGRect)frame andText:(NSString*)text;

- (CGFloat)sizeOfHeightFromText:(NSString*)theText;
- (CGFloat)sizeOfHeightFromBoldText:(NSString*)theText;

- (CGFloat)sizeOfWidthFromText:(NSString*)theText;
- (CGFloat)sizeOfWidthFromBoldText:(NSString*)theText;

- (BOOL)nodesExceedFrameWidthForSum:(CGFloat)sum;

@end
