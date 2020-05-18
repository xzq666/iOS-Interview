//
//  ViewController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/4/21.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "ViewController.h"
#import "UIController.h"
#import "AnimationController.h"
#import "OCGroundController.h"
#import "OCLanguageController.h"
#import "MessagePassController.h"
#import "KVOController.h"
#import "KVCController.h"
#import "CategoryController.h"
#import "BlockController.h"
#import "RuntimeController.h"
#import "RunLoopController.h"
#import "MultiThreadController.h"
#import "MemeryManageController.h"
#import "InfrastructureController.h"
#import "PerformsController.h"
#import "ImageController.h"
#import "DataSafeEncryptController.h"
#import "DebugController.h"

@interface Module : NSObject
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *subTitle;
@end
@implementation Module
@end

@interface ViewController ()<TestDelegate>

@property(nonatomic,strong) NSMutableArray *dataSource;

@property(nonatomic,copy) NSString *backValue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"iOS面试分析";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    // 数据源
    self.dataSource = [[NSMutableArray alloc] init];
    NSArray *titles = @[@"UI相关", @"Animation动画", @"OC对象底层", @"OC语言", @"消息传递方式", @"KVO相关", @"KVC相关", @"分类Category相关", @"block相关", @"Runtime相关", @"RunLoop相关", @"多线程相关", @"内存管理相关", @"项目架构与架构设计", @"性能优化相关", @"图像处理相关", @"数据安全与加密", @"iOS调试技巧"];
    NSArray *subTitles = @[@"UI相关面试题，如UITableView、事件响应链等",
                           @"Animation动画相关面试题，包括隐式动画、核心动画等",
                           @"OC对象底层相关面试题，例如OC对象、isa指针、属性关键字等",
                           @"OC语言相关面试题，主要来自Foundation框架",
                           @"消息传递方式相关面试题，包括通知、代理等",
                           @"KVO相关面试题，例如KVO原理、触发KVO方式等",
                           @"KVC相关面试题，例如KVC的赋值、取值过程等",
                           @"分类Category相关面试题，包括分类的实现原理、加载过程等",
                           @"block相关面试题，例如block原理、__block修饰符、block循环引用等",
                           @"Runtime相关面试题，包括Runtime方法缓存、Runtime黑魔法等",
                           @"RunLoop相关面试题，例如RunLoop的运行模式、常驻线程、RunLoop作用等",
                           @"多线程相关面试题，例如多线程的概念、线程与进程的关系、多线程的优缺点等",
                           @"内存管理相关面试题，例如iOS内存分区、内存管理方式等",
                           @"项目架构与架构设计相关面试题，包括MVC、MVVM、MVP、RAC以及单例模式、工厂模式等",
                           @"性能优化相关面试题，包括tableView滑动卡顿优化、APP启动时间优化等",
                           @"图像处理相关面试题，包括图像压缩方式，图像内存大小计算等",
                           @"数据安全与加密相关面试题，包括对称加密与不对称加密、iOS签名机制等",
                           @"iOS调试技巧相关面试题，包括LLDB常用命令、断点调试等"];
    [self loadNewData:titles sub:subTitles];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getValueFromVC:) name:@"getValueFromVC" object:nil];
}

- (void)loadNewData:(NSArray *)titles sub:(NSArray *)subTitles {
    for (int i = 0; i < titles.count; i++) {
        Module *model = [[Module alloc] init];
        model.title = titles[i];
        model.subTitle = subTitles[i];
        [self.dataSource addObject:model];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    Module *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.subTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            UIController *vc = [[UIController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 1: {
            AnimationController *vc = [[AnimationController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 2: {
            OCGroundController *vc = [[OCGroundController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 3: {
            OCLanguageController *vc = [[OCLanguageController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 4: {
            MessagePassController *vc = [[MessagePassController alloc] init];
            vc.delegate = self;
            vc.block = ^(NSString *param1, NSString * param2) {
                NSString *value = [NSString stringWithFormat:@"%@ - %@", param1, param2];
                NSLog(@"获取到block返回过来的页面值：%@", value);
            };
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 5: {
            KVOController *vc = [[KVOController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 6: {
            KVCController *vc = [[KVCController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 7: {
            CategoryController *vc = [[CategoryController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 8: {
            BlockController *vc = [[BlockController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 9: {
            RuntimeController *vc = [[RuntimeController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 10: {
            RunLoopController *vc = [[RunLoopController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 11: {
            MultiThreadController *vc = [[MultiThreadController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 12: {
            MemeryManageController *vc = [[MemeryManageController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 13: {
            InfrastructureController *vc = [[InfrastructureController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 14: {
            PerformsController *vc = [[PerformsController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 15: {
            ImageController *vc = [[ImageController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 16: {
            DataSafeEncryptController *vc = [[DataSafeEncryptController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 17: {
            DebugController *vc = [[DebugController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        default:
            break;
    }
}

- (void)getValueFromVC:(NSNotification *)noti {
    NSDictionary *dict = noti.object;
    NSString *value = [NSString stringWithFormat:@"%@ - %@", dict[@"param1"], dict[@"param2"]];
    NSLog(@"获取到通知返回过来的页面值：%@", value);
}

- (void)testWithParam1:(NSString *)param1 param2:(NSString *)param2 {
    NSString *value = [NSString stringWithFormat:@"%@ - %@", param1, param2];
    NSLog(@"获取到delegate返回过来的页面值：%@", value);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getValueFromVC" object:nil];
}

@end
