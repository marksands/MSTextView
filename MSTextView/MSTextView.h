//
//  WBTextView.h
//  MSTextView
//
//  Created by Mark Sands on 12/4/10.
//  Copyright 2010 Mark Sands. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSTextViewDelegate <NSObject>
- (void)handleURL:(NSURL*)url;
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