//
//  OCGroundController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/4/23.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "OCGroundController.h"
#import "XZQTriangleButton.h"
#import "CopyingModel.h"
#import <LocalAuthentication/LocalAuthentication.h>

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
    
    XZQTriangleButton *btn = [[XZQTriangleButton alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    btn.buttonClick = ^(void) {
        [self loginButtonClick];
    };
    [self.view addSubview:btn];
    
    CopyingModel *model1 = [[CopyingModel alloc] init];
    model1.name = @"xzq";
    model1.age = 15;
    NSLog(@"model1- %p - %@ - %d", model1, model1.name, model1.age);
    
    CopyingModel *model2 = [model1 copy];
    NSLog(@"model2- %p - %@ - %d", model2, model2.name, model2.age);
    model2.age = 20;
    NSLog(@"model1- %p - %@ - %d", model1, model1.name, model1.age);
    
    CopyingModel *model3 = [model1 mutableCopy];
    NSLog(@"model3- %p - %@ - %d", model3, model3.name, model3.age);
    model3.age = 30;
    NSLog(@"model1- %p - %@ - %d", model1, model1.name, model1.age);
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
    
    NSArray *arr1 = @[@"1"];
    NSMutableArray *arr2 = [arr1 mutableCopy];
    [arr2 addObject:@"2"];
    NSLog(@"arr1:%@", arr1);
    NSLog(@"arr2:%@", arr2);
}

- (void)loginButtonClick {
    // 创建LAContext
    LAContext *context = [LAContext new];
    // 这个属性是设置指纹输入失败之后的弹出框的选项
    context.localizedFallbackTitle = @"输入密码";
    context.localizedCancelTitle = @"取消";
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请按home键进行指纹登录" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"登录成功");
                });
            } else {
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"系统取消授权，如其他APP切入");
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"用户取消验证Touch ID");
                        break;
                    }
                    case LAErrorAuthenticationFailed:
                    {
                        NSLog(@"授权失败");
                        break;
                    }
                    case LAErrorPasscodeNotSet:
                    {
                        NSLog(@"系统未设置密码");
                        break;
                    }
                    case LAErrorTouchIDNotAvailable:
                    {
                        NSLog(@"设备Touch ID不可用，例如未打开");
                        break;
                    }
                    case LAErrorTouchIDNotEnrolled:
                    {
                        NSLog(@"设备Touch ID不可用，用户未录入");
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"用户选择输入密码，切换主线程处理");
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"其他情况，切换主线程处理");
                            [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"指纹验证错误次数过多，请输入密码" reply:^(BOOL success, NSError * _Nullable error) {
                                
                            }];
                        }];
                        break;
                    }
                }
            }
        }];
    } else {
        NSLog(@"不支持指纹识别");
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"指纹验证错误次数过多，请输入密码" reply:^(BOOL success, NSError * _Nullable error) {
            
        }];
        NSLog(@"%@",error.localizedDescription);
    }
}

@end
