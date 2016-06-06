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

#import <UIKit/UIKit.h>

@interface ASConfiguration : NSObject

/*
 *
 * Alert title and working indicator title.
 *
 */

@property (copy, nonatomic) UIFont *titleFont;
@property (copy, nonatomic) UIColor *titleColor;

/*
 *
 * Alert body, slide up menu prompt.
 *
 */

@property (copy, nonatomic) UIColor *bodyFont;
@property (copy, nonatomic) UIColor *bodyColor;

/*
 *
 * Button title color.
 *
 */

@property (copy, nonatomic) UIFont *buttonTitleFont;
@property (copy, nonatomic) UIColor *buttonTitleColorNormal;
@property (copy, nonatomic) UIColor *buttonTitleColorCancel;
@property (copy, nonatomic) UIColor *buttonTitleColorDestructive;

/*
 *
 * Working indicator color.
 *
 */

@property (copy, nonatomic) UIColor *workingSpinnerColor;

/*
 *
 * Popover background color
 *
 */

@property (copy, nonatomic) UIColor *backgroundColor;

/*
 *
 * Seporator line color
 *
 */

@property (copy, nonatomic) UIColor *seporatorLineColor;

@end
