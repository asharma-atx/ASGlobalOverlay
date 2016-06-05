//
//  ASConfigurationsUnpacker.m
//  Pods
//
//  Created by Amit Sharma on 6/4/16.
//
//

#import "ASConfigurationsUnpacker.h"

@interface ASConfigurationsUnpacker ()

@property (strong, nonatomic) ASConfigurations *configurations;

@end

@implementation ASConfigurationsUnpacker

#pragma mark - Configuration Unpacker

+ (instancetype)configurationUnpackerWithConfiguration:(ASConfigurations *)configurations{
    
    ASConfigurationsUnpacker *unpacker = [super init];
    
    unpacker.configurations = configurations;
    
    return unpacker;
}

#pragma mark - Title Font

- (UIFont *)titleFont{
    
    if (_configurations.titleFont) return _configurations.titleFont;
    
    return [UIFont fontWithName:@"AvenirNext-Medium" size:18.0f];
}

- (UIColor *)titleColor{
    
    if (_configurations.titleColor) return _configurations.titleColor;
    
    return [UIColor darkGrayColor];
}

#pragma mark - Body

- (UIFont *)bodyFont{
    
    if (_configurations.bodyFont) return _configurations.bodyFont;
    
    return [UIFont fontWithName:@"Avenir Next" size:14.0f];
}

- (UIColor *)bodyColor{
    
    if (_configurations.bodyColor) return _configurations.bodyColor;
    
    return [UIColor darkGrayColor];
}

#pragma mark - Button

- (UIFont *)buttonTitleFont{
    
    if (_configurations.buttonTitleFont) return _configurations.buttonTitleFont;
    
    return [UIFont fontWithName:@"Avenir Next" size:14.0f];
}

- (UIColor *)buttonTitleColorNormal{
    
    if (_configurations.buttonTitleColorNormal) return _configurations.buttonTitleColorNormal;
    
    return [UIColor darkGrayColor];
}

- (UIColor *)buttonTitleColorCancel{
    
    if (_configurations.buttonTitleColorNormal) return _configurations.buttonTitleColorNormal;
    
    return [UIColor colorWithWhite:0.5f alpha:1.0f];
}

- (UIColor *)buttonTitleColorDestructive{
    
    if (_configurations.buttonTitleColorCancel) return _configurations.buttonTitleColorCancel;
    
    return [UIColor colorWithRed:0.730f green:0.121f blue:0.130f alpha:1.00f];
}

#pragma mark - Working Indicator Spinner

- (UIColor *)workingSpinnerColor{
    
    if (_configurations.workingSpinnerColor) return _configurations.workingSpinnerColor;
    
    return nil;
}

#pragma mark - General

- (UIColor *)backgroundColor{
    
    if (_configurations.backgroundColor) return _configurations.backgroundColor;
    
    return [UIColor colorWithWhite:0.95f alpha:1.0];
}

- (UIColor *)seporatorLineColor{
    
    if (_configurations.seporatorLineColor) return _configurations.seporatorLineColor;
    
    return [UIColor colorWithWhite:0.85f alpha:1.0f];
}

@end
