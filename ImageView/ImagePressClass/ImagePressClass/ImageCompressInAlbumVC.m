//
//  ImageScaleInAlbumVC.m
//  ImagePressClass
//
//  Created by EOC on 2017/4/16.
//  Copyright © 2017年   All rights reserved.
//

#import "ImageCompressInAlbumVC.h"

@interface ImageCompressInAlbumVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    UIImage *_albumImage;
}

@end

@implementation ImageCompressInAlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"压缩相册图片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(openAlbum:)];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (_albumImage) {
        [self imageDataLoad];
    }
    
}

- (void)imageDataLoad{
    
    NSData *pngData = UIImagePNGRepresentation(_albumImage);
    
    // 压塑图片至36KB或压塑到质量的0.1，
    float scale = 0.9;
    NSData *jpgData = UIImageJPEGRepresentation(_albumImage, scale);
    while (jpgData.length > 36*1024) {
        scale = -0.1;
        jpgData = UIImageJPEGRepresentation(_albumImage, scale);
        if (scale <= 0.1) {
            break;
        }
    }
    
    NSLog(@"png:%@", [self sizeFormDataLenght:pngData.length]);
    NSLog(@"jpg:%@", [self sizeFormDataLenght:jpgData.length]);
    
    [_pngImageV setImage:[UIImage imageWithData:pngData]];
    [_jpgImageV setImage:[UIImage imageWithData:pngData]];
    
    [self saveImageToLocal:@"JPG.jpg" fromData:jpgData];
    [self saveImageToLocal:@"png.png" fromData:pngData];
    
    UIImage *image = [UIImage imageWithData:pngData];
    image = [self scaleImage:image size:CGSizeMake(100, 100)];
    [self saveImageToLocal:@" png" fromData:UIImageJPEGRepresentation(image,1)];
}


// 保存图片数据到本地
- (void)saveImageToLocal:(NSString*)fileName fromData:(NSData*)data{
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    filePath = [filePath stringByAppendingPathComponent:fileName];
    if ([data writeToFile:filePath atomically:YES]) {
        NSLog(@"sucess");
    }
}

// 获取图片长度
- (NSString *)sizeFormDataLenght:(long)length{
    
    NSString *backStr = nil;
    float size_KB = length/1024.0;
    if (size_KB < 1024) {
        backStr = [NSString stringWithFormat:@"%0.2fKB", size_KB];
    }else {
        backStr = [NSString stringWithFormat:@"%0.2fMB", size_KB/1024.0];
    }
    return backStr;
}

// 通过上下文对图片压缩处理
- (UIImage*)scaleImage:(UIImage*)image size:(CGSize)imageSize{
    
    UIGraphicsBeginImageContext(imageSize);
    [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)openAlbum:(id)sender{
    
    UIImagePickerController *imagePickerContr = [[UIImagePickerController alloc] init];
    imagePickerContr.delegate = self;
    imagePickerContr.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerContr animated:YES completion:nil];
    
}

#pragma mark - UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    NSLog(@"%s", __func__);
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"%s", __func__);
    
    _albumImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    NSLog(@"%s", __func__);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
