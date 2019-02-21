//
//  QRCodeCIImageVC.m
//  ImagePressClass
//
//  Created by Casey on 15/02/2019.
//  Copyright © 2019 EOC. All rights reserved.
//

#import "QRCodeCIImageVC.h"
#import <CoreImage/CoreImage.h>

@interface QRCodeCIImageVC (){
    
    
    UIImageView *_imageView;
    
    CIImage *_ciImage;
    
}

@end

@implementation QRCodeCIImageVC


- (void)loadView {
    
    UIScrollView *scrollerView = [[UIScrollView alloc] init];
    scrollerView.backgroundColor = UIColor.whiteColor;
    [scrollerView setContentSize:CGSizeMake(UIScreen.mainScreen.bounds.size.width + 100, UIScreen.mainScreen.bounds.size.height + 100)];
    self.view = scrollerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"QR";
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"imageLoad" style:UIBarButtonItemStylePlain target:self action:@selector(imageLoad)];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 300)];
    [self.view addSubview:_imageView];
    
}


- (void)imageLoad {
    
    [self filterFunction];
    
    return;
    
    [self qrCodeProduct:nil content:@"http://www.xxxxx.com"];
    _imageView.image = [UIImage imageWithCIImage:_ciImage];
}


- (void)filterFunction {
    
    static int __imageIndex = 0;
    NSArray *filterNameArr = @[@"CIColorControls", @"CIPhotoEffectMono", @"CIPhotoEffectTonal", @"CIPhotoEffectNoir", @"CIPhotoEffectFade", @"CIPhotoEffectChrome", @"CIPhotoEffectProcess"];
    
    NSString *filterName = filterNameArr[__imageIndex%filterNameArr.count];
    CIFilter *filter = [CIFilter filterWithName:filterName];
    CIImage *inputImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"bigImage.jpg"]];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    _imageView.image = [UIImage imageWithCIImage:filter.outputImage]; // 这个卡在GPU， 没卡CPU， 可以看输出
    
    NSLog(@"%@", filterName);
    __imageIndex++;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
}


- (void)qrCodeProduct:(UIImageView*)targetImageView content:(NSString*)content{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName =  @"111.png";
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        UIImage *cacheImage = [UIImage imageWithContentsOfFile:filePath];
        
        if (cacheImage) {

            dispatch_async(dispatch_get_main_queue(), ^{

                targetImageView.image = cacheImage;

            });
            return ;
        }
        // 查看所有的滤镜名字列表 [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
        
        /*
         滤镜提供什么样的输入和输出参数
         qrFilter.inputKeys  和 qrFilter.outputKeys
         参数描述： qrFilter.attributes
         
         */
        
        CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        
        [qrFilter setDefaults];
        [qrFilter setValue:[content dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
        CIImage *ciimage = qrFilter.outputImage;
        // 放大图片的比例
        ciimage = [ciimage imageByApplyingTransform:CGAffineTransformMakeScale(9, 9)];
        _ciImage = ciimage;
        
        CGFloat scale =  UIScreen.mainScreen.scale;
        CGFloat width = ciimage.extent.size.width*scale;
        CGFloat height = ciimage.extent.size.height*scale;
        
        CIContext *ciContext = [CIContext contextWithOptions:nil];
        CGRect extent = CGRectIntegral(ciimage.extent);
        CGImageRef ciImageRef = [ciContext createCGImage:ciimage fromRect:extent];
        
        
        CGColorSpaceRef colorspaceRef = CGColorSpaceCreateDeviceRGB();
        NSUInteger bytesPerPixel = 4;
        NSUInteger bytesPerRow = bytesPerPixel * width;
        NSUInteger bitsPerComponent = 8;
        CGContextRef context = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, bytesPerRow, colorspaceRef, kCGBitmapByteOrderDefault|kCGImageAlphaPremultipliedLast);
        if (context == nil) {
            bytesPerPixel = 16;
            bytesPerRow = bytesPerPixel * width;
            context = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, bytesPerRow, colorspaceRef, kCGBitmapByteOrderDefault|kCGImageAlphaPremultipliedLast);
            if (context == nil) {
                bytesPerPixel = 32;
                bytesPerRow = bytesPerPixel * width;
                context = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, bytesPerRow, colorspaceRef, kCGBitmapByteOrderDefault|kCGImageAlphaPremultipliedLast);
            }
        }
        
        
        
        
        CGContextSaveGState(context);
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), ciImageRef);
        CGContextRestoreGState(context);
        
        // 7.画log
        UIImage *meImage = [UIImage imageNamed:@"AppIcon.png"];
        CGFloat meImageW = 50*scale;
        CGFloat meImageH = 50*scale;
        CGFloat meImageX = (width - meImageW) * 0.5;
        CGFloat meImageY = (height - meImageH) * 0.5;
        
        
        CGContextSaveGState(context);
        CGContextDrawImage(context, CGRectMake(meImageX, meImageY, meImageW, meImageH), meImage.CGImage);
        CGContextRestoreGState(context);
        
        
        
        
        CGImageRef imageRef =  CGBitmapContextCreateImage(context);
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
        
        if (context) {
            CFRelease(context);
        }
        if (imageRef) {
            CFRelease(imageRef);
        }
        if (ciImageRef) {
            CFRelease(ciImageRef);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            targetImageView.image = image;
            
        });
        
        NSData *data = UIImagePNGRepresentation(image);
        [data writeToFile:filePath atomically:NO];
        
        
        
        
        
    });
    
}
@end
