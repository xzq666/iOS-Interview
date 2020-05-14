//
//  InfrastructureController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/14.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "InfrastructureController.h"
#import "MVCAppleController.h"
#import "MVCChangeController.h"
#import "MVPController.h"
#import "MVVMController.h"

@interface InfrastructureController ()

@property(nonatomic,strong) NSArray *dataSource;

@end

@implementation InfrastructureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"项目架构与架构设计";
    
    self.dataSource = @[@"MVC-Apple", @"MVC变种", @"MVP", @"MVVM"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            MVCAppleController *vc = [[MVCAppleController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 1: {
            MVCChangeController *vc = [[MVCChangeController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 2: {
            MVPController *vc = [[MVPController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 3: {
            MVVMController *vc = [[MVVMController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        default:
            break;
    }
}

@end
