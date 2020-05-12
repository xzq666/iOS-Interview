//
//  CopyModel.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/12.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "CopyModel.h"

@implementation CopyModel

// 当调用CopyModel的copy方法时会触发这个代理方法
- (id)copyWithZone:(NSZone *)zone {
    CopyModel *model = [[CopyModel alloc] init];
    model.age = self.age;
    model.name = self.name;
    return model;
}

@end
