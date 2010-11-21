//
//  MSLinkElement.h
//  UITextViewLinkOptions
//
//  Created by Mark Sands on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSElement.h"

@protocol MSLinkDelegate
- (void) handleURL:(NSString*)url;
@end

@interface MSLinkElement : MSElement {
  NSString *_URL;
  id<MSLinkDelegate> delegate;
  
  UIView *_screenView;
}

@property (nonatomic, assign) id<MSLinkDelegate> delegate;

@property (nonatomic, retain) NSString *URL;
@property (nonatomic, retain) UIView *_screenView;

- (id) initWithFrame:(CGRect)frame andURL:(NSString*)URL;
- (void)handleURL;

@end
