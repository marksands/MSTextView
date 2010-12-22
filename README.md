# MSTextView

A URL aware TextView for iOS

## Installation

Just copy over `MSTextView.m` and `MSTextView.h` into your project folder and you're all set.

# Using MSTextView

This is an early release, so be aware of bugs. I designed this to be a drop-in replacement of UITextView for each view that you wanted to have link aware.

Make sure to include the header file `"MSTextView.h"` and use the protocol `<MSTextViewDelegate>` which is necessary for responding to your code when the user selects a link. The sample project has everything you need to get you started, or check out the code below.

    - (void) viewDidLoad {

      NSString *sample = @"Follow me on twitter @marksands or check out the latest #Apple trends on http://www.twitter.com";

      MSTextView *textView = [[MSTextView alloc] initWithFrame:CGRectMake(10, 10, 300, 395)];
      textView.delegate = self;
      textView.font = [UIFont fontWithName:@"Helvetica" size:20];
      textView.text = sample;
      [self.view addSubview:textView];
      [textView release];
    }

    #pragma Delegate
    - (void) handleURL:(NSURL*)url
    {
      WebViewController *webview = [[WebViewController alloc] initWithURL:url];
      [self.navigationController pushViewController:webview animated:YES];
      [webview release];
    }

![http://img.skitch.com/20101202-xmjjjthqknh8wcdskwfqbcfqum.png](http://img.skitch.com/20101202-xmjjjthqknh8wcdskwfqbcfqum.png)
![http://img.skitch.com/20101202-98jtrsq1ptxifantqrm7grha.png](http://img.skitch.com/20101202-98jtrsq1ptxifantqrm7grha.png)
![http://img.skitch.com/20101202-8i6ktqke26uh1yfaeb1j284typ.png](http://img.skitch.com/20101202-8i6ktqke26uh1yfaeb1j284typ.png)

# License 

Copyright (c) 2010 Mark Sands

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
