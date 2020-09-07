//
//  ImageController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/16.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "ImageController.h"

@interface ImageController ()

@end

@implementation ImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    };
    self.title = @"图像相关处理";
    
    UIImage *image = [UIImage imageNamed:@"female_icon"];
    NSLog(@"fileSize: %@", [self calulateImageFileSize:image]);
}

- (NSString *)calulateImageFileSize:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 0.5);  // 需要改成0.5才接近原图片大小
    if (!data) {
        data = UIImagePNGRepresentation(image);
    }
    double dataLength = [data length] * 1.0;
    NSArray *typeArray = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB",@"ZB",@"YB"];
    NSInteger index = 0;
    while (dataLength > 1024) {
        dataLength /= 1024.0;
        index ++;
    }
    return [NSString stringWithFormat:@"%.3f%@",dataLength,typeArray[index]];
}

@end
