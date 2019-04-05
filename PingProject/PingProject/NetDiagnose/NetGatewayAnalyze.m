//
//  NetGatewayAnalyze.m
//  PingProject
//
//  Created by Casey on 29/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import "NetGatewayAnalyze.h"
#import <AFNetworking.h>


@interface NetGatewayAnalyze (){
    
    dispatch_queue_t _serialQueue;
}


@end


@implementation NetGatewayAnalyze


- (instancetype)init {
    
    self = [super init];
    if (self) {
        _serialQueue = dispatch_queue_create("gatewayOperationQueue", DISPATCH_QUEUE_SERIAL);
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    
    return self;
}


- (void)startAddressIPByService {
    
    
    dispatch_async(_serialQueue, ^{
        
        NSURL *ipURL = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo2.php?ip=myip"];
        NSData *data = [NSData dataWithContentsOfURL:ipURL];
        NSDictionary *ipDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *ipStr = nil;
        
        if (ipDic && [ipDic[@"code"] integerValue] == 0) { //获取成功
            ipStr = ipDic[@"data"][@"ip"];
        }
        
        NSLog(@"===%@",ipStr ? ipStr : @"");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
        
    });
    
   
    
}


- (void)checkGateway:(NSArray*)gatewayArr progress:(void(^)(AnalyzeDataModel *dataModel))progress completion:(void(^)(NSArray<AnalyzeDataModel*> *analyzeArr))completion{
    
    
    dispatch_async(_serialQueue, ^{
        
        NSMutableArray *resultArr = [NSMutableArray array];
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        for (NSInteger i = 0; i < gatewayArr.count; i++) {
            
            AnalyzeDataModel *model = [AnalyzeDataModel new];
            model.gatewayUrl = gatewayArr[i];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:gatewayArr[i]]];
            
            request.HTTPMethod = @"GET";
            request.timeoutInterval = 10;
            NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970] * 1000;
            NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                
                
                NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970] * 1000;
                
                
                if (response) {
                    
                    NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse*)response;
                    model.timeDuration = endTime - startTime;
                    if (urlResponse.statusCode != 200) {
                        model.errorCode = urlResponse.statusCode;
                    }
                    
                }else {
                    
                    model.detail = error.userInfo[NSLocalizedDescriptionKey];;
                    model.errorCode = error.code;
                    model.timeDuration = FailSpeedCode;
                }
                
                dispatch_semaphore_signal(sem);
                
                
                if (progress) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        progress(model);
                    });
                    
                }
            }];
            
            
            [task resume];
            
            model.networkType = [self networkType];
            
            dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
            
            [resultArr addObject:model];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (completion) {
                completion(resultArr);
            }
            
        });
    });
    
}

- (NSString *)networkType {
    
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    switch (status) {
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return @"wifi";
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return @"WWAN";
        case AFNetworkReachabilityStatusNotReachable:
            return @"disconnect";
        default:
            return @"unkown";
    }
}


- (void)dealloc {
    
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    
}

@end



@implementation AnalyzeDataModel



@end

@implementation GatewayDataModel



@end


