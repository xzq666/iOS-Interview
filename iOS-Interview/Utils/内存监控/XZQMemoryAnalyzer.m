//
//  XZQMemoryAnalyzer.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/10/15.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQMemoryAnalyzer.h"
#import <mach/mach.h>

@implementation XZQMemoryAnalyzer

// 已用内存
vm_size_t getUsedMemory() {
    task_basic_info_data_t info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    if (kerr == KERN_SUCCESS) {
        return info.resident_size;
    } else {
        return 0;
    }
}

// 可用内存
vm_size_t getFreeMemory() {
    mach_port_t host = mach_host_self();
    mach_msg_type_number_t size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vmstat;
    host_page_size(host, &pagesize);
    host_statistics(host, HOST_VM_INFO, (host_info_t)&vmstat, &size);
    return vmstat.free_count * pagesize;
}

@end
