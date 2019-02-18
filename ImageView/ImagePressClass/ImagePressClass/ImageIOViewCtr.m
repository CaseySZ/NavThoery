//
//  ImageIOViewCtr.m
//  ImagePressClass
//
//  Created by Casey on 15/01/2019.
//  Copyright © 2019 EOC. All rights reserved.
//

#import "ImageIOViewCtr.h"
#import <ImageIO/ImageIO.h>

@interface ImageIOViewCtr (){
    
    
    IBOutlet UIImageView *_imageView;
    IBOutlet UIImageView *_twoImageView;
    CGImageSourceRef _source;
    CGImageSourceRef _incrementalSource;
    NSMutableData *_imageData;
}

@end

@implementation ImageIOViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ImageIO";
    
    
    
    UIBarButtonItem *decodeItem = [[UIBarButtonItem alloc] initWithTitle:@"decode" style:UIBarButtonItemStylePlain target:self action:@selector(decodeImage)];
    UIBarButtonItem *thumbNailItem = [[UIBarButtonItem alloc] initWithTitle:@"thumbNail" style:UIBarButtonItemStylePlain target:self action:@selector(thumbNail)];
    
    self.navigationItem.rightBarButtonItems = @[decodeItem, thumbNailItem];
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys: @(YES), kCGImageSourceShouldCacheImmediately, nil];
    infoDict = nil;
    _incrementalSource = CGImageSourceCreateIncremental((__bridge CFDictionaryRef)infoDict);
    
    _imageData = [NSMutableData data];
    
}


- (void)dealloc {
    
    CFRelease(_source);
    
}

- (NSData *)readFileData:(NSInteger)startOffset {
    
  //  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mew_baseline" ofType:@"jpg"];
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mew_interlaced" ofType:@"png"];
    
  //  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bigSize" ofType:@"jpg"];
  //  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"gif" ofType:@"gif"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"11" ofType:@"jpg"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    if (startOffset + 1024*4  >  fileData.length) {
        
        NSData *readData = [fileData subdataWithRange: NSMakeRange(startOffset, fileData.length - startOffset)];
        return readData;
        
    }else {
        
        NSData *readData = [fileData subdataWithRange: NSMakeRange(startOffset, 1024*4)];
        return readData;
    }
    
}


// 获取略缩图， 查看 略缩图size
- (void)thumbNail {
    
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys: @(YES), kCGImageSourceCreateThumbnailFromImageIfAbsent, @(YES), kCGImageSourceCreateThumbnailFromImageAlways, nil];
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bigSize" ofType:@"jpg"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bigImage" ofType:@"jpg"];
 //   NSString *filePath = [[NSBundle mainBundle] pathForResource:@"gif" ofType:@"gif"];
  //  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mew_baseline" ofType:@"jpg"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    _source = CGImageSourceCreateWithData((__bridge CFDataRef)fileData, (__bridge CFDictionaryRef)infoDict);
    
    CGImageRef imageRef =  CGImageSourceCreateThumbnailAtIndex(_source, 0, NULL);
    //CGImageRef imageRef = CGImageSourceCreateImageAtIndex(thumbnailSourceRef, 0, nil);
    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
    
    
    
    _imageView.image = image;
    
    if (imageRef) {
        CFRelease(imageRef); // 读文件属性的时候， imageRef是nil
    }
    
    
}

// 解码属性
- (void)decodeImage {
    
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys: @(YES), kCGImageSourceShouldCacheImmediately, @(YES), kCGImageSourceShouldCache, nil];
   
  //  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bigSize" ofType:@"jpg"];
 //   NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mew_baseline" ofType:@"jpg"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"11" ofType:@"jpg"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    _source = CGImageSourceCreateWithData((__bridge CFDataRef)fileData, (__bridge CFDictionaryRef)infoDict);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_source, 0, nil);
    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
    
    
    _imageView.image = image;
    
    if (imageRef) {
        CFRelease(imageRef); // 读文件属性的时候， imageRef是nil
    }
}


// 渐进显示
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
   

    NSData *readData = [self readFileData:_imageData.length];
    [_imageData appendData:readData];
    
    CFDataRef dataRef = (__bridge CFDataRef)_imageData;
    CGImageSourceUpdateData(_incrementalSource, dataRef, false);
    
 //   NSLog(@"count::%d", CGImageSourceGetCount(_source));
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys: @(YES), kCGImagePropertyFileContentsDictionary, nil];
    NSLog(@"%@", CGImageSourceCopyProperties(_source, (__bridge CFDictionaryRef)infoDict));
    
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_incrementalSource, 0, nil);
    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
        
    _imageView.image = image;
    
    if (imageRef) {
        CFRelease(imageRef); // 读文件属性的时候， imageRef是nil
    }
    
    
    
    
}







@end
