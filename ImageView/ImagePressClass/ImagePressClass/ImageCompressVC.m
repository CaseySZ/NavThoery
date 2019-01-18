

//
//  ImageCompressVC.m
//  ImagePressClass
//
//  Created by Casey on 18/01/2019.
//  Copyright © 2019 EOC. All rights reserved.
//

#import "ImageCompressVC.h"

@interface ImageCompressVC ()

@end

@implementation ImageCompressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"image compress";
    
}


// 通过上下文对图片压缩处理
- (void)scaleImage{
    
    
    UIImage *image = [UIImage imageNamed:@"bigImage.jpg"];
    CGSize imageSize = CGSizeMake(100, 100);
   
    UIGraphicsBeginImageContext(imageSize);
    [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self saveImageToLocal:@"testTT png" fromData:UIImageJPEGRepresentation(newImage,1)];
    
}

// 保存图片数据到本地
- (void)saveImageToLocal:(NSString*)fileName fromData:(NSData*)data{
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    filePath = [filePath stringByAppendingPathComponent:fileName];
    NSLog(@"filePath:%@", filePath);
    [data writeToFile:filePath atomically:YES];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    [self scaleImage];
    
}


@end
