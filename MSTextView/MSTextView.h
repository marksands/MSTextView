//
//  WBTextView.h
//  MSTextView
//
//  Created by Mark Sands on 12/4/10.
//  Copyright 2010 Mark Sands. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSTextView;

@protocol MSTextViewDelegate
- (void)handleURL:(NSURL*)url;
- (void)textViewDidAdjustHeight:(MSTextView *)textView;
@end


@interface MSTextView : UIView <UIWebViewDelegate> {
  id<MSTextViewDelegate> delegate;
  NSString *_text;
  UIFont *_font;
  UIWebView *_aWebView;
}

@property (nonatomic, assign) id<MSTextViewDelegate> delegate;

@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UIWebView *aWebView;

@end