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
}

@property (nonatomic, assign) id<MSLinkDelegate> delegate;

@property (nonatomic, retain) NSString *URL;

- (id) initWithFrame:(CGRect)frame andURL:(NSString*)URL;
- (void)handleURL;

@end
