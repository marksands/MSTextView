//
//  NSString+Replace.h
//  MSTextView
//
//  Created by Mark Sands on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (replace)

+ (NSString *) replaceText:(NSString *)textContents ofTargetString:(NSString *)targetString withString:(NSString *)replaceString;

@end


@implementation NSString (replace)

+ (NSString *) replaceText:(NSString *)textContents ofTargetString:(NSString *)targetString withString:(NSString *)replaceString
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSMutableString *temp = [[NSMutableString alloc] init];
  NSRange replaceRange = NSMakeRange(0, [textContents length]);
  NSRange rangeInOriginalString = replaceRange;    /* Range in the original string where we do the searches */
  int replaced = 0;
  
  // The following loop can execute an unlimited number of times, and  it could have autorelease activity.
  // To keep things under control, we use a pool, but to be a bit  efficient, instead of emptying everytime through
  // the loop, we do it every so often. We can only do this as long as  autoreleased items are not supposed to
  // survive between the invocations of the pool!
  
  while (1) {
    NSRange rangeToCopy;
    NSRange foundRange = [textContents rangeOfString:targetString
                                             options:0 range:rangeInOriginalString];
    // Because we computed the tightest range above, foundRange should always be valid.
    if (foundRange.length == 0) break;
    rangeToCopy = NSMakeRange(rangeInOriginalString.location,
                              foundRange.location - rangeInOriginalString.location);
    [temp appendString:[textContents
                        substringWithRange:rangeToCopy]];
    [temp appendString:replaceString];
    rangeInOriginalString.length -= NSMaxRange(foundRange) -
    rangeInOriginalString.location;
    rangeInOriginalString.location = NSMaxRange(foundRange);
    replaced++;
    if (replaced % 100 == 0) {    // Refresh the pool... See warnings above!
      [pool release];
      pool = [[NSAutoreleasePool alloc] init];
    }
  }
  if (rangeInOriginalString.length > 0) [temp appendString:[textContents substringWithRange:rangeInOriginalString]];
  [pool release];
  
  return [temp autorelease];
}

@end