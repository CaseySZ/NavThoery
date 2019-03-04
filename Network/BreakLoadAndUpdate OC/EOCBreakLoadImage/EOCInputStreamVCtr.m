//
//  EOCInputStreamVCtr.m
//  EOCBreakLoadImage
//
//  Created by EOC on 2017/6/14.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EOCInputStreamVCtr.h"



@interface EOCInputStreamVCtr ()<NSURLSessionDelegate, NSURLConnectionDataDelegate>{
    
    
}

@property (nonatomic, strong)NSInputStream *inputStream;


@end

@implementation EOCInputStreamVCtr

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@", docPath);
    
    NSString *bodyStr = @"versions_id=1&system_type=1";
    self.inputStream = [[NSInputStream alloc] initWithData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    // self.inputStream = [[NSInputStream alloc] initWithFileAtPath:FilePathInDocument(@"data")];
//    [self.inputStream open];
//    [self.inputStream close];
    
    // open之后读完是有偏移量的， close，再读，重新开始读
    
    //    char buffer[256];
    //    [self.inputStream read:buffer maxLength:9];
    //
    //    buffer[9] = 0;
    //    NSLog(@"===%s", buffer);
    //    [self.inputStream close];
    //
    //    [self.inputStream open];
    //    [self.inputStream read:buffer maxLength:3];
    //
    //    buffer[3] = 0;
    //    NSLog(@"===%s", buffer);
    //     [self.inputStream close];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self netLoadDelegate];
}

- (void)netLoadDelegate
{
    
    NSURL *url = [NSURL URLWithString:URLPath];
    
    //请求体
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"POST"]; //
    [request setHTTPBodyStream:self.inputStream];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request];
    [task resume];
    
}

//NSURLConnection
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    // 进度，在这里处理逻辑 UI 操作在主线程
    NSDictionary *infoDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"%@", infoDict);
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"==%@", error);
}


@end
