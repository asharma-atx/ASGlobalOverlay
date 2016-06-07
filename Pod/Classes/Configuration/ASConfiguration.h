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

#import <UIKit/UIKit.h>

// ===============
// ASConfiguration
// ===============

/**
 *
 * An instance of ASConfiguration represents a configuration of ASGlobalOverlay.
 * 
 * Once an instance of ASConfiguration is created, make it active by calling +setConfiguration: on ASGlobalOverlay.
 * Alternatively, you can make a configuration object the set configuration by calling -makeCurrentConfiguration on it.
 *
 */

@interface ASConfiguration : NSObject

/**
 *
 * Font used for alert title and working indicator description.
 *
 */

@property (copy, nonatomic) UIFont *titleFont;

/**
 *
 * Font color used for alert title and working indicator description.
 *
 */

@property (copy, nonatomic) UIColor *titleColor;

/**
 *
 * Font used for alert body and slide up menu prompt.
 *
 */

@property (copy, nonatomic) UIFont *bodyFont;

/**
 *
 * Font color used for alert body and slide up menu prompt.
 *
 */

@property (copy, nonatomic) UIColor *bodyColor;

/**
 *
 * Font used for all buttons.
 *
 */

@property (copy, nonatomic) UIFont *buttonTitleFont;

/**
 *
 * Font color used for normal buttons.
 *
 */

@property (copy, nonatomic) UIColor *buttonTitleColorNormal;

/**
 *
 * Font color used for cancel buttons.
 *
 */

@property (copy, nonatomic) UIColor *buttonTitleColorCancel;

/**
 *
 * Font color used for buttons that have destructive results.
 *
 */

@property (copy, nonatomic) UIColor *buttonTitleColorDestructive;

/**
 *
 * Working indicator color.
 *
 */

@property (copy, nonatomic) UIColor *workingSpinnerColor;

/**
 *
 * Popover background color.
 *
 */

@property (copy, nonatomic) UIColor *backgroundColor;

/**
 *
 * Separator line color.
 *
 */

@property (copy, nonatomic) UIColor *separatorLineColor;

#pragma mark - Helpers

/**
 *
 * Helper method for quickly creating custom configurations.
 *
 * @param foregroundColor The color of all the fonts, the separator line, and the working indicator spinner.
 *
 * @param backgroundColor The color of popover background.
 *
 */

+ (instancetype)configurationWithForegroundColor:(UIColor *)foregroundColor backgroundColor:(UIColor *)backgroundColor;

/**
 *
 * Returns a night-themed configuration object.
 *
 */

+ (instancetype)nightTheme;

/**
 *
 * Returns a typewriter-themed configuration object.
 *
 */

+ (instancetype)typewriterTheme;

/**
 *
 * Returns a latte-themed configuration object.
 *
 */

+ (instancetype)latteTheme;

#pragma mark - Dynamic Font

/**
 *
 * Returns a configuration object that uses the given font names and the system dynamic font sizes.
 * If no font name is given, the default system fonts are used.
 * Does not include a color scheme. Therefore, the default color scheme will be used unless otherwise set.
 *
 */

+ (instancetype)configurationWithDynamicFontSizesWithTitleFontName:(NSString *)titleFontName bodyFontName:(NSString *)bodyFontName buttonFontName:(NSString *)buttonFontName;

#pragma mark - Make Current

/**
 *
 * Makes the configuration the current configuration.
 * This is the same as manually setting the configuration via [ASGlobalOverlay setConfiguration:yourConfiguration].
 *
 */

- (void)makeCurrentConfiguration;

@end
