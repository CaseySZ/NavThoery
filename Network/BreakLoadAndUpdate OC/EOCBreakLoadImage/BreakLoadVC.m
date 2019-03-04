//
//  ViewController.m
//  EOCBreakLoadImage
//
//  Created by EOC on 2017/6/13.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "BreakLoadVC.h"
#import "ProjectFile.h"

/* 
 */



/*
 
 下载到一半突然出现问题（网络问题）
 下次再去下载（就基于上一个的网络数据，继续执行）
 
 一刚开始的设置（网络数据不会马上放到目的地方）
 
 和平常的下载任务不同， 有个中转站
 
 */



@interface BreakLoadVC ()<NSURLSessionDelegate, NSURLConnectionDataDelegate>{
    
    NSMutableData *_imageData;
}

@property (nonatomic, strong)NSString *fileName; // 过渡文件名（URL）


@end


@implementation BreakLoadVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"断点下载";
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@", docPath);
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self loadImage];
}

- (void)loadImage
{
    //地址
    self.fileName = [[ImageURL componentsSeparatedByString:@"/"] lastObject];
    
    NSURL *url = [NSURL URLWithString:ImageURL];
    
    //请求体
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    // 去中转站找，是否有这个网络请求相关数据
    long dataPreLeght = [self backFileLegnth:self.fileName];
    [request setValue:[NSString stringWithFormat:@"bytes=%ld-40000", dataPreLeght] forHTTPHeaderField:@"Range"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request];
    [task resume];
    
}

- (long)backFileLegnth:(NSString*)fileName{
    
    NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:FilePathInTemp(fileName) error:nil];
    long fileLength = (long)[[fileDict objectForKey:NSFileSize] unsignedLongLongValue];
    return fileLength;
}


//NSURLConnection
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    // 中转站
    [data writeToFile:FilePathInTemp(self.fileName) atomically:YES];
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    
    // 转移
    [[NSFileManager defaultManager] moveItemAtPath:FilePathInTemp(self.fileName) toPath:FilePathInDocument(self.fileName) error:nil];
    NSLog(@"%@", error);
    
}


@end
