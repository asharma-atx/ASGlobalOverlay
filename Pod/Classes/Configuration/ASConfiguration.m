//
//  ASConfiguration.m
//  Pods
//
//  Created by Amit Sharma on 6/4/16.
//
//

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

#pragma mark - Make Current

- (void)makeCurrentConfiguration{
    
    [ASGlobalOverlay setConfiguration:self];
}

@end
