//
//  ImageScaleInAlbumVC.m
//  ImagePressClass
//
//  Created by EOC on 2017/4/16.
//  Copyright © 2017年   All rights reserved.
//

#import "ImageFileCompressInAlbumVC.h"

@interface ImageFileCompressInAlbumVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    UIImage *_albumImage;
}

@end

@implementation ImageFileCompressInAlbumVC

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

// ⚠️ 这个不是真正意义上的压缩，只是文件的压缩，这个操作一般可用于上传
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



/*
 
 */

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [_pngImageV setImage:[UIImage imageNamed:@"1.png"]];
    
}

- (IBAction)openAlbum:(id)sender{
    
    UIImagePickerController *imagePickerContr = [[UIImagePickerController alloc] init];
    imagePickerContr.delegate = self;
    imagePickerContr.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerContr animated:YES completion:nil];
    
}

#pragma mark - UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
  
    _albumImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
