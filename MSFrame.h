//
//  MSFrame.h
//  UITextViewLinkOptions
//
//  Created by Mark Sands on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MSNode;

@interface MSFrame : NSObject {
  MSNode *_root;
}

@property (nonatomic, assign) MSNode *root;

- (id) initWithRootNode:(MSNode*)node;

@end
