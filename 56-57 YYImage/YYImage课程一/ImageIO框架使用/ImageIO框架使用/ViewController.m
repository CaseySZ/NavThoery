//
//  ViewController.m
//  ImageIO框架使用
//
//  Created by 八点钟学院 on 2017/7/14.
//  Copyright © 2017年 八点钟学院. All rights reserved.
//

#import "ViewController.h"
#import <ImageIO/ImageIO.h>
#import "NextViewController.h"
#import "EOCImage.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(100.f, 100.f, 100.f, 100.f);
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    [self showEOCImage];
//    [self getImageInfo];
    
//    [self logImageType];
    
//    [self isBigEndianOrLittleEndian];
    
//        [self showEOCImage];

}

- (void)showEOCImage {
    
    
    
}


//获取图片信息, 这里颜色空间、颜色模型、色品、InterlaceType都得详细标注
- (void)getImageInfo {
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mew_interlaced" ofType:@"png"];
    NSData *data = [NSData dataWithContentsOfFile:path];

    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    //CGImageSourceCopyProperties  用这个获取的是图片组的信息，没单个图片多,  有文件大小
    CFDictionaryRef imageMetaData = CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
//    CFDictionaryRef imageData = CGImageSourceCopyProperties(source, NULL);
    
    CFRelease(source);

    NSDictionary *metaDataInfo    = CFBridgingRelease(imageMetaData);
    NSLog(@"%@", metaDataInfo);
    
}

//判断平台是大端还是小端：无论是32位还是64位，char都是1个字节
- (void)isBigEndianOrLittleEndian {
    
    unsigned int a, *p;
    p = &a;
    a = 0;  //*p = 0x00000000
    *(char *)p = 0xff;  //p[0]
    
    //大端的话，高位存储在低地址；  小端，低位存于低地址
    //所以，大端会是：0xff000000   小端是:0x000000ff  //11111111
    
    NSLog(@"p%d", *p);
    
    //linux的大端和小端判断
    static union { char c[4]; unsigned int mylong; } endian_test = {{ 'l', '?', '?', 'b' } };
    
    NSLog(@"%c", ((char)endian_test.mylong));
}


- (void)btnAction {
    
    NextViewController *nextViewCtrl = [[NextViewController alloc] init];
    [self presentViewController:nextViewCtrl animated:YES completion:nil];
    
}

//打印ImageIO框架所支持的图片格式
- (void)logImageType {
    
   CFArrayRef sourceArr = CGImageSourceCopyTypeIdentifiers();
   CFShow(sourceArr);
   CFArrayRef destinationArr = CGImageDestinationCopyTypeIdentifiers();
   CFShow(destinationArr);
    
}



@end
