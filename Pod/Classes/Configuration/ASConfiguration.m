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

#import "ASConfiguration.h"
#import "ASGlobalOverlay.h"

@implementation ASConfiguration

+ (instancetype)configurationWithForegroundColor:(UIColor *)foregroundColor backgroundColor:(UIColor *)backgroundColor{
    
    ASConfiguration *configuration = [ASConfiguration new];
    
    configuration.backgroundColor = backgroundColor;
    configuration.titleColor = foregroundColor;
    configuration.bodyColor = foregroundColor;
    configuration.workingSpinnerColor = foregroundColor;
    configuration.separatorLineColor = foregroundColor;
    configuration.buttonTitleColorNormal = foregroundColor;
    configuration.buttonTitleColorCancel = foregroundColor;
    configuration.buttonTitleColorDestructive = foregroundColor;
    
    return configuration;
}

+ (instancetype)nightTheme{

    
    ASConfiguration *configuration = [ASConfiguration configurationWithForegroundColor:[UIColor colorWithRed:0.667 green:0.706 blue:0.800 alpha:1.00]
                                                                      backgroundColor:[UIColor colorWithRed:0.082 green:0.102 blue:0.137 alpha:1.00]];
    
    return configuration;
}

+ (instancetype)typewriterTheme{
    
    ASConfiguration *configuration = [ASConfiguration configurationWithForegroundColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor]];
    
    configuration.titleFont = [UIFont fontWithName:@"Courier-Bold" size:17.0f];
    configuration.bodyFont = [UIFont fontWithName:@"Courier" size:14.0f];
    configuration.buttonTitleFont = [UIFont fontWithName:@"Courier" size:14.0f];
    
    return configuration;
}

+ (instancetype)latteTheme{
    
    ASConfiguration *configuration = [ASConfiguration configurationWithForegroundColor:[UIColor colorWithRed:0.271 green:0.090 blue:0.000 alpha:1.00]
                                                                       backgroundColor:[UIColor colorWithRed:0.973 green:0.945 blue:0.894 alpha:1.00]];
    
    return configuration;
}

#pragma mark - Dynamic Font

+ (instancetype)configurationWithDynamicFontSizesWithTitleFontName:(NSString *)titleFontName bodyFontName:(NSString *)bodyFontName buttonFontName:(NSString *)buttonFontName{

    ASConfiguration *configuration = [ASConfiguration new];
    
    if (titleFontName){
        
        CGFloat titleFontSize = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline].pointSize;
        configuration.titleFont = [UIFont fontWithName:titleFontName size:titleFontSize];
    }
    
    else{
        
        configuration.titleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    }
    
    if (bodyFontName){
        
        CGFloat bodyFontSize = [UIFont preferredFontForTextStyle:UIFontTextStyleBody].pointSize;
        configuration.bodyFont = [UIFont fontWithName:bodyFontName size:bodyFontSize];
    }
    
    else{
        
        configuration.bodyFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    
    if (buttonFontName){
        
        CGFloat buttonFontSize = [UIFont preferredFontForTextStyle:UIFontTextStyleBody].pointSize;
        configuration.buttonTitleFont = [UIFont fontWithName:buttonFontName size:buttonFontSize];
    }
    
    else{
        
        configuration.buttonTitleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    
    return configuration;
}

#pragma mark - Make Current

- (void)makeCurrentConfiguration{
    
    [ASGlobalOverlay setConfiguration:self];
}

@end
