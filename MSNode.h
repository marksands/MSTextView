//
//  MSNode.h
//  UITextViewLinkOptions
//
//  Created by Mark Sands on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MSNode : NSObject {
  MSNode *_parent;
  MSNode *_child;
}

@property (nonatomic, assign) MSNode* parent;
@property (nonatomic, retain) MSNode* child;

- (id)initWithChild:(MSNode*)childNode;

@end
