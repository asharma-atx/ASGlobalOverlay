//
//  ASConfigurationsUnpacker.h
//  Pods
//
//  Created by Amit Sharma on 6/4/16.
//
//

#import <Foundation/Foundation.h>
#import "ASConfigurations.h"

@interface ASConfigurationsUnpacker : NSObject

+ (instancetype)configurationUnpackerWithConfiguration:(ASConfigurations *)configurations;

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
- (UIColor *)seporatorLineColor;

@end
