//
//  EOCUpdateFileVCtr.m
//  EOCBreakLoadImage
//
//  Created by EOC on 2017/6/14.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EOCUpdateFileVCtr.h"
#define UpdateImageURL @"http://www.8pmedu.com/themes/jianmo/img/upload.php"

/*
 http://www.8pmedu.com/themes/jianmo/img/upload.php
 */

@interface EOCUpdateFileVCtr ()<NSURLSessionDelegate, NSURLConnectionDataDelegate>{
    
    NSMutableData *_bodyData;
}

@property (nonatomic, strong)NSInputStream *inputStream;

@end


@implementation EOCUpdateFileVCtr

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"文件上传";
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@", docPath);
    
     _bodyData = [NSMutableData data];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
     _bodyData = [NSMutableData data];
    [self netLoadDelegate];
}


/*
 头设置 类型（key） 分解线（key） content-lenght
 
 
 body（配置头（属性和服务器的key）） 
 分界线开始
  文件数据
 分界线结束
 
 */


- (void)configBody:(NSData*)fileData boundary:(NSString*)boundary{
    
    NSString *serverContentTypes = @"image/png";
    NSString *serverFileKey  = @"image";
    NSString *serverFileName = @"center_6bg9.png";
    
    // body分界 ⚠️--没有出问题的
    NSString *startBoundary = [NSString stringWithFormat:@"--%@\r\n", boundary];
    
    NSString *endBoundary = [NSString stringWithFormat:@"\r\n--%@", boundary];
    
    NSMutableString *bodyStr = [NSMutableString string];
    
    
    // body 头
    /*
      serverFileKey服务器取得字段
      serverFileName 服务器存的文件名
     
     // 如果服务器那边读key是imageFile 我们前端传的key是image
     file[image] = serverFileName
     
     */
    /*
      头 AFHTTPBodyPart（NSInputStream）
     */
    [bodyStr appendFormat:@"%@", startBoundary];
    [bodyStr appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\" \r\n", serverFileKey, serverFileName];
    [bodyStr appendFormat:@"Content-Type: %@\r\n", serverContentTypes];
    [bodyStr appendFormat:@"\r\n"];// ⚠️ 表头结束符号（相当于就有两个\r\n）
    
    // 加入表头
    [_bodyData appendData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    // 体：图片数据了
    [_bodyData appendData:fileData];
    // 结束符
    [_bodyData appendData:[endBoundary dataUsingEncoding:NSUTF8StringEncoding]];
    
}


- (void)netLoadDelegate
{
    NSURL *url = [NSURL URLWithString:UpdateImageURL];
    //请求头
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"]; //
    
    NSString *boundarySign = @"********"; //分界线
    [request setValue:[NSString stringWithFormat:@"multipart/form-data;charset=utf-8;boundary=%@", boundarySign] forHTTPHeaderField:@"Content-Type"];
 //   [request setValue:[NSString stringWithFormat:@"%ld", _bodyData.length] forHTTPHeaderField:@"Content-Length"];
    
    
    // body
    UIImage *image = [UIImage imageNamed:@"1.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    [self configBody:imageData boundary:boundarySign];
    [request setHTTPBody:_bodyData];
    
//    NSLog(@"<---------------->");
//    for (int i = 0; i < _bodyData.length; i++) {
//        printf("%c", buffer[i]);
//    }
//    NSLog(@"<---------------->");
    
//    self.inputStream = [[NSInputStream alloc] initWithData:_bodyData];
//    [request setHTTPBodyStream:self.inputStream];
    
    
    /*
     request head 设置
     multipart/form-data 是上传二进制数据 （上传文件必须用这个）
     application/x-www-form-urlencoded 标准（默认）的编码格式，名称／值对
     */
    
    
    /*
     body 不一样，不在key1=Value1&key2=Value2 
     
     */
    

    
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
   
    NSDictionary *infoDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (infoDict) {
        NSLog(@"==%@", infoDict);
    }else{
        NSLog(@"===%s", [data bytes]);
    }
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"==%@", error);
}

@end
