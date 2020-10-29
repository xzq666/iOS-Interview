//
//  IMLoginController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/10/16.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "IMLoginController.h"

#import "Message.pbobjc.h"
#import "ReplyBody.pbobjc.h"
#import "SentBody.pbobjc.h"

@interface IMLoginController ()

@end

@implementation IMLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登录";
    
    Message *message = [[Message alloc] init];
    message.content = @"Message content";
    NSLog(@"message content - %@", message.content);
}

@end
