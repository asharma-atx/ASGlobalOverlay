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

#import "ASConfigurationHandler.h"

@interface ASConfigurationHandler ()

@property (strong, nonatomic) ASConfiguration *configuration;

@end

@implementation ASConfigurationHandler

#pragma mark - Init

+ (instancetype)configurationHandlerWithConfiguration:(ASConfiguration *)configuration{
    
    ASConfigurationHandler *handler = [[ASConfigurationHandler alloc] init];
    
    handler.configuration = configuration;
    
    return handler;
}

#pragma mark - Title Font

- (UIFont *)titleFont{
            
    if (_configuration.titleFont) return _configuration.titleFont;
    
    return [UIFont fontWithName:@"AvenirNext-Medium" size:18.0f];
}

- (UIColor *)titleColor{
    
    if (_configuration.titleColor) return _configuration.titleColor;
    
    return [UIColor darkGrayColor];
}

#pragma mark - Body

- (UIFont *)bodyFont{
    
    if (_configuration.bodyFont) return _configuration.bodyFont;
    
    return [UIFont fontWithName:@"Avenir Next" size:14.0f];
}

- (UIColor *)bodyColor{
    
    if (_configuration.bodyColor) return _configuration.bodyColor;
    
    return [UIColor darkGrayColor];
}

#pragma mark - Button

- (UIFont *)buttonTitleFont{
    
    if (_configuration.buttonTitleFont) return _configuration.buttonTitleFont;
    
    return [UIFont fontWithName:@"AvenirNext-Medium" size:14.0f];
}

- (UIColor *)buttonTitleColorNormal{
    
    if (_configuration.buttonTitleColorNormal) return _configuration.buttonTitleColorNormal;
    
    return [UIColor darkGrayColor];
}

- (UIColor *)buttonTitleColorCancel{
    
    if (_configuration.buttonTitleColorNormal) return _configuration.buttonTitleColorNormal;
    
    return [UIColor colorWithWhite:0.5f alpha:1.0f];
}

- (UIColor *)buttonTitleColorDestructive{
    
    if (_configuration.buttonTitleColorCancel) return _configuration.buttonTitleColorCancel;
    
    return [UIColor colorWithRed:0.730f green:0.121f blue:0.130f alpha:1.00f];
}

#pragma mark - Working Indicator Spinner

- (UIColor *)workingSpinnerColor{
    
    if (_configuration.workingSpinnerColor) return _configuration.workingSpinnerColor;
    
    return [UIColor darkGrayColor];
}

#pragma mark - General

- (UIColor *)backgroundColor{
    
    if (_configuration.backgroundColor) return _configuration.backgroundColor;
    
    return [UIColor colorWithWhite:0.95f alpha:1.0];
}

- (UIColor *)separatorLineColor{
    
    if (_configuration.separatorLineColor) return _configuration.separatorLineColor;
    
    return [UIColor colorWithWhite:0.85f alpha:1.0f];
}

@end
