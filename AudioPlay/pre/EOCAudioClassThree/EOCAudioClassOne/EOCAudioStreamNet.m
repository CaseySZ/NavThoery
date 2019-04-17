
//
//  EOCAudioStreamNet.m
//  EOCAudioClassOne
//
//  Created by EOC on 2017/7/3.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EOCAudioStreamNet.h"



@implementation EOCAudioStreamNet


- (void)startLoadMusic:(NSString*)urlStr offset:(long)offset{
    
    if (urlStr.length == 0)
        return;

    if (_task) {
        [_task cancel];
    }
    
    NSURL *musicUrl = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:musicUrl];
    [request setHTTPMethod:@"GET"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    
    if (offset > 0) {
        [request setValue:[NSString stringWithFormat:@"bytes=%@-", @(offset)] forHTTPHeaderField:@"Range"];
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
    [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"II"];
    
    _task = [session dataTaskWithRequest:request];
    
    if (_task) {
        [_task resume];
    }
}

// 每次读1000
- (NSData*)readDataOfLength:(int)length isPlay:(BOOL)isPlay{
    
    NSData *backMusicData = nil;
    
    if (audioNetData.length - audioReadedData.length >= length) {
        
        backMusicData = [audioNetData subdataWithRange:NSMakeRange(audioReadedData.length, length)];
        
    }else{
        // 数据不足length 阻塞
        [self waitNetData:isPlay];
    }
    
    [audioReadedData appendData:backMusicData];
    
    return backMusicData;
}


- (void)_mutexInit{
    
    pthread_mutex_init(&_mutex, NULL);
    pthread_cond_init(&_cond, NULL);
    
}


- (void)waitNetData:(BOOL)isPlay{
    
    NSLog(@"waitNetData");
    if (isPlay == NO) {
        [self signalEnughtData];
    }else {
        pthread_mutex_lock(&_mutex);
        pthread_cond_wait(&_cond, &_mutex);
        pthread_mutex_unlock(&_mutex);
    }
}

- (void)signalEnughtData{
    
    NSLog(@"数据足了");
    pthread_mutex_lock(&_mutex);
    pthread_cond_signal(&_cond);
    pthread_mutex_unlock(&_mutex);
}

- (void)mutexDestory{
    
    pthread_mutex_destroy(&_mutex);
    pthread_cond_destroy(&_cond);
}

#pragma  mark - NSURLSession Delegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    
    completionHandler(NSURLSessionResponseAllow);
    
    audioNetData = [NSMutableData data];
    audioReadedData  = [NSMutableData data];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(netHandleDataWithResponse:)]) {
        
        NSHTTPURLResponse *httpRespon = (NSHTTPURLResponse*)response;
        [self.delegate netHandleDataWithResponse:httpRespon.allHeaderFields];
    }
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
 
    [audioNetData appendData:data];
    
    [self signalEnughtData];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{

    _isFinish = YES;
}


- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    
}


@end
