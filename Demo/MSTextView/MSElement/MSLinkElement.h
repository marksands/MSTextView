//
//  MSLinkElement.h
//  UITextViewLinkOptions
//
//  Created by Mark Sands on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSElement.h"

@protocol MSLinkDelegate <NSObject>
- (void) didSelectURL:(NSURL *)url;
@end

@interface MSLinkElement : MSElement {
  NSURL *_URL;
  id<MSLinkDelegate> delegate;
  
  UIView *_screenView;
}

@property (nonatomic, assign) id<MSLinkDelegate> delegate;

@property (nonatomic, retain) NSURL *URL;
@property (nonatomic, retain) UIView *screenView;

- (id)initWithFrame:(CGRect)frame andURL:(NSURL *)URL;
- (void)didSelectURL;

@end
