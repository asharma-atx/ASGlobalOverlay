//
//  ASConfigurationHandler.h
//  Pods
//
//  Created by Amit Sharma on 6/4/16.
//
//

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
