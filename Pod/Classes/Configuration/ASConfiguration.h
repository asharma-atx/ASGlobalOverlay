//
//  ASConfiguration.h
//  Pods
//
//  Created by Amit Sharma on 6/4/16.
//
//

// TODO #DEPLOY COPYWRIGHT STUFF
// TODO REWRITE DOCS
// TODO SPELL CHECK
// TODO Create stock configs
// TODO ANALYZE
// TODO REMOVE PODSPEC PATH FOR CONFIGURE FILE

#import <UIKit/UIKit.h>

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

@property (copy, nonatomic) UIColor *bodyFont;

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
 * Font color used for buttons that have descructive results.
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
 * Seporator line color.
 *
 */

@property (copy, nonatomic) UIColor *seporatorLineColor;

#pragma mark - Helpers

/**
 *
 * Helper method for quickly creating custom configurations. The returned object can be further customized.
 *
 * @param foregroundColor The color of all the fonts, the seporator line, and the working indicator spinner.
 *
 * @param backgroundColor The color of popover background.
 *
 */

+ (instancetype)configurationWithForgroundColor:(UIColor *)foregroundColor backgroundColor:(UIColor *)backgroundColor;

/**
 *
 * Returns a night-themed configuration object.
 *
 */

+ (instancetype)nightTheme;

@end
