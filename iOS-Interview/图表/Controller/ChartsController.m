//
//  ChartsController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/10/16.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "ChartsController.h"
#import <AAChartKit/AAGlobalMacro.h>
#import <AAChartKit/AAChartKit.h>

@interface ChartsController ()

@property(nonatomic,strong) AAChartView *aaChartView;

@end

@implementation ChartsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat chartViewWidth  = self.view.frame.size.width;
    CGFloat chartViewHeight = self.view.frame.size.height-250;
    self.aaChartView = [[AAChartView alloc]initWithFrame:CGRectMake(0, 60, chartViewWidth, chartViewHeight)];
    ////设置图表视图的内容高度(默认 contentHeight 和 AAChartView 的高度相同)
    //self.aaChartView.contentHeight = self.view.frame.size.height-250;
    [self.view addSubview:self.aaChartView];
    
    AAChartModel *aaChartModel= AAObject(AAChartModel)
    .chartTypeSet(AAChartTypeArea)//设置图表的类型(这里以设置的为折线面积图为例)
    .titleSet(@"编程语言热度")//设置图表标题
    .subtitleSet(@"虚拟数据")//设置图表副标题
    .categoriesSet(@[@"Java",@"Swift",@"Python",@"Ruby", @"PHP",@"Go",@"C",@"C#",@"C++"])//图表横轴的内容
    .yAxisTitleSet(@"摄氏度")//设置图表 y 轴的单位
    .seriesSet(@[
            AAObject(AASeriesElement)
            .nameSet(@"2017")
            .dataSet(@[@7.0, @6.9, @9.5, @14.5, @18.2, @21.5, @25.2, @26.5, @23.3]),
            AAObject(AASeriesElement)
            .nameSet(@"2018")
            .dataSet(@[@0.2, @0.8, @5.7, @11.3, @17.0, @22.0, @24.8, @24.1, @20.1]),
            AAObject(AASeriesElement)
            .nameSet(@"2019")
            .dataSet(@[@0.9, @0.6, @3.5, @8.4, @13.5, @17.0, @18.6, @17.9, @14.3]),
            AAObject(AASeriesElement)
            .nameSet(@"2020")
            .dataSet(@[@3.9, @4.2, @5.7, @8.5, @11.9, @15.2, @17.0, @16.6, @14.2]),
                     ])
    ;
    
    /*图表视图对象调用图表模型对象,绘制最终图形*/
    [_aaChartView aa_drawChartWithChartModel:aaChartModel];
}

@end
