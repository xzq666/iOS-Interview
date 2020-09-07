//
//  OCGroundController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/4/23.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "OCGroundController.h"

@interface OCGroundController ()

// 使用strong关键字修饰NSString，可能会在对象不知道的情况下被更改
@property(nonatomic,strong) NSString *str1;
// 使用copy关键字修饰NSString，确保对象中的字符串不会无意间被改变
@property(nonatomic,copy) NSString *str2;

@end

@implementation OCGroundController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"OC底层";
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    };
    
    [self copyTest];
}

- (void)copyTest {
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:@"hello world"];
    self.str1 = @"this is str";
    self.str2 = @"this is str";
    self.str1 = mutableString;  // str1指针会指向mutableString
    self.str2 = mutableString;  // str2只是拿到了mutableString的拷贝，内容拷贝
    // 此时改变可变字符串的值
    [mutableString setString:@"change"];
    // 被strong修饰的NSString被更改了，被copy修饰的不会更改
    NSLog(@"str1 is %@, str2 is %@", self.str1, self.str2);
}

@end
