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

@end
