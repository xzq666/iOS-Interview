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
#import "CodeController.h"
#import "CalenderEventController.h"
#import "RunLoopWatchCatonController.h"
#import "ChartsController.h"
#import "IMLoginController.h"
#import "MemoryMoveController.h"

@interface Module : NSObject
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *subTitle;
@property(nonatomic,copy) NSString *controllerName;
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
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    };
    
    NSMethodSignature *signature = [ViewController instanceMethodSignatureForSelector:@selector(sendMessageWithPhone:WithName:)];
    NSInvocation *invacation = [NSInvocation invocationWithMethodSignature:signature];
    invacation.target = self;
    invacation.selector = @selector(sendMessageWithPhone:WithName:);
    NSString *phone = @"15389898989";
    NSString *name = @"xza";
    // 0为self 1位_cmd
    [invacation setArgument:&phone atIndex:2];
    [invacation setArgument:&name atIndex:3];
    [invacation invoke];
    
    // 判断是否是越狱机
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"]) {
        NSLog(@"此设备已越狱");
    } else {
        NSLog(@"此设备未越狱");
    }
    
    NSLog(@"1235");
    // 1.主队列,不是自己创建的,是从系统获得,是一个特殊的串行队列,一定对应主线程
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    for (int i = 0; i<20; i++) {
        dispatch_async(mainQueue, ^{
            NSLog(@"%d->%@",i,[NSThread currentThread]);
        });
    }
    NSLog(@"呵呵");
    
    // 数据源
    self.dataSource = [[NSMutableArray alloc] init];
    NSArray *titles = @[@"UI相关", @"Animation动画", @"OC对象底层", @"内存平移", @"OC语言", @"消息传递方式", @"KVO相关", @"KVC相关", @"分类Category相关", @"block相关", @"Runtime相关", @"RunLoop相关", @"多线程相关", @"内存管理相关", @"项目架构与架构设计", @"性能优化相关", @"图像处理相关", @"数据安全与加密", @"iOS调试技巧", @"源码理解", @"日历和提醒事项", @"卡顿监控测试", @"图表", @"IM"];
    NSArray *subTitles = @[@"UI相关面试题，如UITableView、事件响应链等",
                           @"Animation动画相关面试题，包括隐式动画、核心动画等",
                           @"OC对象底层相关面试题，例如OC对象、isa指针、属性关键字等",
                           @"OC对象底层相关面试题，内存平移的分析验证",
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
                           @"iOS调试技巧相关面试题，包括LLDB常用命令、断点调试等",
                           @"源码理解相关面试题，包括SDWebImage、AFNetworking等",
                           @"用Eventkit向日历和提醒事项中加入事件和闹铃",
                           @"使用RunLoop进行实时卡顿监控测试",
                           @"使用AAChartKit框架制作各种图表",
                           @"IM聊天相关"
    ];
    NSArray *controllerTitles = @[@"UIController", @"AnimationController", @"OCGroundController", @"MemoryMoveController", @"OCLanguageController", @"MessagePassController", @"KVOController", @"KVCController", @"CategoryController", @"BlockController", @"RuntimeController", @"RunLoopController", @"MultiThreadController", @"MemeryManageController", @"InfrastructureController", @"PerformsController", @"ImageController", @"DataSafeEncryptController", @"DebugController", @"CodeController", @"CalenderEventController", @"RunLoopWatchCatonController", @"ChartsController", @"IMLoginController"];
    [self loadNewData:titles sub:subTitles controllerNames:controllerTitles];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getValueFromVC:) name:@"getValueFromVC" object:nil];

}

- (void)sendMessageWithPhone:(NSString*)phone WithName:(NSString*)name {
    NSLog(@"􏹧􏳃􏴗=%@, 􏹨􏲦=%@", phone, name);
}

- (void)loadNewData:(NSArray *)titles sub:(NSArray *)subTitles controllerNames:(NSArray *)controllerNames {
    for (int i = 0; i < titles.count; i++) {
        Module *model = [[Module alloc] init];
        model.title = titles[i];
        model.subTitle = subTitles[i];
        model.controllerName = controllerNames[i];
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
    Module *model = self.dataSource[indexPath.row];
    if (indexPath.row == 5) {
        MessagePassController *vc = [[NSClassFromString(model.controllerName) alloc] init];
        vc.delegate = self;
        vc.block = ^(NSString *param1, NSString * param2) {
            NSString *value = [NSString stringWithFormat:@"%@ - %@", param1, param2];
            NSLog(@"获取到block返回过来的页面值：%@", value);
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        UIViewController *vc = [[NSClassFromString(model.controllerName) alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
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
