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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"QR";
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"imageLoad" style:UIBarButtonItemStylePlain target:self action:@selector(imageLoad)];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:_imageView];
    
}


- (void)imageLoad {
    
    _imageView.image = [UIImage imageWithCIImage:_ciImage];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    [self qrCodeProduct:nil content:@"http://www.xxxxx.com"];
    
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
