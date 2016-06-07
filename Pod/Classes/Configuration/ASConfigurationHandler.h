//
// ASGlobalOverlay
//
// Copyright (c) 2016 Amit Sharma <amitsharma@mac.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "ASConfiguration.h"

@interface ASConfigurationHandler : NSObject

+ (instancetype)configurationHandlerWithConfiguration:(ASConfiguration *)configuration;

#pragma mark - Title Font

- (UIFont *)titleFont;
- (UIColor *)titleColor;

#pragma mark - Body

- (UIFont *)bodyFont;
- (UIColor *)bodyColor;

#pragma mark - Button

- (UIFont *)buttonTitleFont;
- (UIColor *)buttonTitleColorNormal;
- (UIColor *)buttonTitleColorCancel;
- (UIColor *)buttonTitleColorDestructive;

#pragma mark - Working Indicator Spinner

- (UIColor *)workingSpinnerColor;

#pragma mark - General

- (UIColor *)backgroundColor;
- (UIColor *)separatorLineColor;

@end
