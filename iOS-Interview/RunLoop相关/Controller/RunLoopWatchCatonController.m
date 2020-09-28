//
//  RunLoopWatchCatonController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/9/27.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "RunLoopWatchCatonController.h"

@interface RunLoopWatchCatonController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@end

@implementation RunLoopWatchCatonController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    };
    self.title = @"RunLoop实时监控卡顿";
    
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify =@"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    if (indexPath.row % 10 == 0) {
        usleep(1 * 1000 * 1000); // 模拟卡顿 1秒
        cell.textLabel.text = @"卡咯";
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    }
    return cell;
}

@end
