# MSTextView

A URL aware TextView for iOS

## Background

Over the summer, I found a hack that solved my problem of having an "in app Safari" for links activated from UITextViews. I made a demo project  [here](https://github.com/marksands/UITextViewLinkOptions) and even [blogged](http://52apps.net/post/879106231/method-swizzling-uitextview-and-safari) about it. However, I'm 99.9% sure that Apple won't allow this "hack" to go through the App Store. I know the API can handle this more effectively with entities, but I threw this little project together anyway since I needed something now. If you are using my hack, I suggest you switch to using this method if you need an immediate solution to get you through the app store.

## Using MSTextView

This is a very early release, so be aware of bugs. I (hopefully) designed this to be a drop-in replacement of UITextView for each TextView that you wanted to have link aware.

Make sure to include the header file `"MSTextView.h"` and use the protocol `<MSTextViewDelegate>` which is necessary for responding to your code when the user selects a link. The sample project has everything you need to get you started, or check out the code below.

    - (void) viewDidLoad {

      NSString *sample = @"Check out my GitHub page http://github.com/marksands or go to http://google.com instead. \
        Optionally, try out a news site such as http://yahoo.com or http://cnn.com";

      MSTextView *textView = [[MSTextView alloc] initWithFrame:CGRectMake(10, 10, 310, 480)];
      textView.delegate = self;
      textView.text = sample;
      [self.view addSubview:textView];
      [textView release];
    }

    #pragma Delegate
    - (void) handleURL:(NSString*)url
    {
      WebViewController *webview = [[WebViewController alloc] initWithURL:[NSURL URLWithString:url]];
      [self.navigationController pushViewController:webview animated:YES];
      [webview release];
    }

## License 

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
