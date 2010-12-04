//
//  WBTextView.h
//  MSTextView
//
//  Created by Mark Sands on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WBTextViewDelegate
- (void)handleURL:(NSURL*)url;
@end


@interface WBTextView : UIView <UIWebViewDelegate> {
  id delegate;
  NSString *_text;
  
  UIWebView *_aWebView;
}

@property (nonatomic, assign) id delegate;
@property (retain) NSString *text;

@property (retain) UIWebView *_aWebView;
@end
