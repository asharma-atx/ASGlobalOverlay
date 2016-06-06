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

+ (instancetype)configurationWithForgroundColor:(UIColor *)foregroundColor backgroundColor:(UIColor *)backgroundColor{
    
    ASConfiguration *configuration = [ASConfiguration new];
    
    configuration.backgroundColor = backgroundColor;
    configuration.titleColor = foregroundColor;
    configuration.bodyColor = foregroundColor;
    configuration.workingSpinnerColor = foregroundColor;
    configuration.seporatorLineColor = foregroundColor;
    configuration.buttonTitleColorNormal = foregroundColor;
    configuration.buttonTitleColorCancel = foregroundColor;
    configuration.buttonTitleColorDestructive = foregroundColor;
    
    return configuration;
}

+ (instancetype)nightTheme{
    
    ASConfiguration *configuration = [ASConfiguration configurationWithForgroundColor:[UIColor colorWithRed:0.459 green:0.502 blue:0.584 alpha:1.00]
                                                                      backgroundColor:[UIColor colorWithRed:0.082 green:0.102 blue:0.137 alpha:1.00]];
    
    configuration.titleColor = [UIColor colorWithRed:0.667 green:0.706 blue:0.800 alpha:1.00];
    
    return configuration;
}

- (void)makeCurrentConfiguration{
    
    [ASGlobalOverlay setConfiguration:self];
}

@end
