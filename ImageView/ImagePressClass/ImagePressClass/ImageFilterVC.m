//
//  ImageFilterVC.m
//  ImagePressClass
//
//  Created by EOC on 2017/4/16.
//  Copyright © 2017年   All rights reserved.
//

#import "ImageFilterVC.h"
#import <CoreFoundation/CoreFoundation.h>

@interface ImageFilterVC ()

@property (nonatomic, strong)UIImage *image;

@end

@implementation ImageFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"图片处理";
   
    UIBarButtonItem *origImageBt = [[UIBarButtonItem alloc] initWithTitle:@"还原" style:UIBarButtonItemStylePlain target:self action:@selector(originalImage)];
    UIBarButtonItem *filterImageBt = [[UIBarButtonItem alloc] initWithTitle:@"过滤" style:UIBarButtonItemStylePlain target:self action:@selector(filterImage)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:origImageBt, filterImageBt, nil];
    self.image = [UIImage imageNamed:@"1.jpg"];
}

- (void)originalImage{
    
}

- (void)filterImage{
    
    _filterImageV.image = [self eocFilter];
    
}

- (UIImage *)eocFilter{
    
    CGImageRef imageRef = self.image.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t bits = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerRow = CGImageGetBytesPerRow(imageRef);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    int alphaInfo = CGImageGetAlphaInfo(imageRef);
    
    CGDataProviderRef provideRef = CGImageGetDataProvider(imageRef);
    CFDataRef dataRef = CGDataProviderCopyData(provideRef);
    int lenght = (int)CFDataGetLength(dataRef);

    ////比较图片大小
//    NSData *data = (__bridge NSData*)dataRef;
//    NSData *dataPng = UIImagePNGRepresentation(self.image);
//    NSData *dataJpG = UIImageJPEGRepresentation(self.image, 1);
    ///
    
    ///////// 测试 data和const char* 
    NSString *testStr = @"abcdefg123456789";
    NSData *testData = [testStr dataUsingEncoding:NSUTF8StringEncoding];
    const char *testC = [testData bytes];
    for (int i = 0; i < testData.length; i++) {
        printf("i->%d: %c\n", i, testC[i]);
    }
    ////////////
    
    UInt8 *pixelBuf = (UInt8 *)CFDataGetMutableBytePtr((CFMutableDataRef)dataRef);
    for (int i = 0; i < lenght; i+=4) {
        //////修改原始像素RGB数据
        [self eocImageFilterFormBuf:pixelBuf offset:i];
    }
    
    CGContextRef contextRef = CGBitmapContextCreate(pixelBuf, width, height, bits, bitsPerRow, colorSpace, alphaInfo);
    
    CGImageRef backImageRef = CGBitmapContextCreateImage(contextRef);
    UIImage *backImage = [UIImage imageWithCGImage:backImageRef scale:[UIScreen mainScreen].scale orientation:self.image.imageOrientation];
    
    CFRelease(dataRef);
    CFRelease(contextRef);
    CFRelease(backImageRef);
    
    return backImage;
    
}

// 对像素点进行加工
- (void)eocImageFilterFormBuf:(UInt8*)pixelBuf offset:(int)offset{
    
    int offsetR = offset;
    int offsetG = offset + 1;
    int offsetB = offset + 2;
    
    int red   = pixelBuf[offsetR];
    int green = pixelBuf[offsetG];
    int blue  = pixelBuf[offsetB];
    
    int gray = (red + green + blue)/3;
    
    pixelBuf[offsetR] = gray;
    pixelBuf[offsetG] = gray;
    pixelBuf[offsetB] = gray;
}


@end
