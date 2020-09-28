//
//  CalenderEventController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/9/2.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "CalenderEventController.h"
#import <EventKit/EventKit.h>
#import <UserNotifications/UserNotifications.h>

@interface CalenderEventController ()<UNUserNotificationCenterDelegate>

@end

@implementation CalenderEventController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"日历和提醒事项";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *birthdayStr=@"2020-09-14 11:45:00";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *birthdayDate = [dateFormatter dateFromString:birthdayStr];
    [self addEventNotify:birthdayDate title:@"您今天预约了外勤事件，请及时签到，若已签到请忽略"];
//    [self addReminderNotify:birthdayDate title:@"测试添加提醒"];
}

- (void)addEventNotify:(NSDate *)date title:(NSString *)title {
    //生成事件数据库对象
    EKEventStore *eventDB = [[EKEventStore alloc] init];
    //申请事件类型权限
    [eventDB requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        if (granted) { //授权是否成功
            EKEvent *myEvent  = [EKEvent eventWithEventStore:eventDB]; //创建一个日历事件
            myEvent.title     = title;  //标题
            myEvent.startDate = date; //开始date   required
            myEvent.endDate   = date;  //结束date    required
//            [myEvent addAlarm:[EKAlarm alarmWithAbsoluteDate:date]]; //添加一个闹钟  optional
            myEvent.alarms = @[[EKAlarm alarmWithRelativeOffset:60.0f * -10.0f], [EKAlarm alarmWithRelativeOffset:60.0f * -5.0f], [EKAlarm alarmWithAbsoluteDate:date]];
            [myEvent setCalendar:[eventDB defaultCalendarForNewEvents]]; //添加calendar  required
            NSError *err;
            [eventDB saveEvent:myEvent span:EKSpanThisEvent error:&err]; //保存
            if (err) {
                NSLog(@"添加事件失败");
            } else {
                NSLog(@"添加事件成功");
            }
        }
    }];
}

- (void)addReminderNotify:(NSDate *)date title:(NSString *)title {
    EKEventStore *eventDB = [[EKEventStore alloc] init];
    //申请提醒权限
    [eventDB requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //创建一个提醒功能
            EKReminder *reminder = [EKReminder reminderWithEventStore:eventDB];
            //标题
            reminder.title = title;
            //添加日历
            [reminder setCalendar:[eventDB defaultCalendarForNewReminders]];
            NSCalendar *cal = [NSCalendar currentCalendar];
            [cal setTimeZone:[NSTimeZone systemTimeZone]];
            NSInteger flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents* dateComp = [cal components:flags fromDate:date];
            dateComp.timeZone = [NSTimeZone systemTimeZone];
            reminder.startDateComponents = dateComp; //开始时间
            reminder.dueDateComponents = dateComp; //到期时间
            reminder.priority = 1; //优先级
            EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:date]; //添加一个闹钟
            [reminder addAlarm:alarm];
            NSError *err;
            [eventDB saveReminder:reminder commit:YES error:&err];
            if (err) {
                NSLog(@"添加提醒失败");
            } else {
                NSLog(@"添加提醒成功");
            }
        }
    }];
}

@end
