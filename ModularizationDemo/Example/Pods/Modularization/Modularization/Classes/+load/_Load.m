//
//  _Load.m
//  Modularization
//
//  Created by sy on 2018/1/19.
//

#import <Modularization/Modularization-swift.h>
#import "_Load.h"

@interface _Load : NSObject

@end

@implementation _Load

+ (void)load {
    [[Modularization shared] registerEntries];
}

@end
