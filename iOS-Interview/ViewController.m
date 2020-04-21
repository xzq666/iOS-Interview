//
//  ViewController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/4/21.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "ViewController.h"
#import "UIController.h"

@interface Module : NSObject
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *subTitle;
@end
@implementation Module
@end

@interface ViewController ()

@property(nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"iOS面试分析";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    // 数据源
    self.dataSource = [[NSMutableArray alloc] init];
    NSArray *titles = @[@"UI相关"];
    NSArray *subTitles = @[@"UI相关面试题，如UITableView、事件响应链等"];
    [self loadNewData:titles sub:subTitles];
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
            
        default:
            break;
    }
}

@end
