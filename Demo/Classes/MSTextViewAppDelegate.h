//
//  MSTextViewAppDelegate.h
//  MSTextView
//
//  Created by Mark Sands on 11/21/10.
//  Copyright Mark Sands 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSTextViewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

