//
//  ASConfigurationHandler.m
//  Pods
//
//  Created by Amit Sharma on 6/4/16.
//
//

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
    
    return [UIFont fontWithName:@"AvenirNext-Medium" size:14.0f]; // better default TODO
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
    
    return nil;
}

#pragma mark - General

- (UIColor *)backgroundColor{
    
    if (_configuration.backgroundColor) return _configuration.backgroundColor;
    
    return [UIColor colorWithWhite:0.95f alpha:1.0];
}

- (UIColor *)seporatorLineColor{
    
    if (_configuration.seporatorLineColor) return _configuration.seporatorLineColor;
    
    return [UIColor colorWithWhite:0.85f alpha:1.0f];
}

@end
