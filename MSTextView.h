//
//  MSTextView.h
//  UITextViewLinkOptions
//
//  Created by Mark Sands on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MSFrame;
@class MSParser;

@interface MSTextView : UIView {
  NSString *_text;
  
  MSFrame  *_Frame;
  MSParser *_Parser;
}

@property (nonatomic, assign) NSString *text;

@property (nonatomic, retain) MSFrame  *Frame;
@property (nonatomic, retain) MSParser *Parser;

- (id) initWithText:(NSString*)text;

@end
