//
//  CopyModel.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/11/25.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "CopyingModel.h"

@interface CopyingModel ()

@end

@implementation CopyingModel

- (id)copyWithZone:(NSZone *)zone {
    CopyingModel *model = [[[self class] allocWithZone:zone] init];
    model.age = [self age];
    model.name = [self name];
    return model;
}

@end
