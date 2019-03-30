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
    }
    
    return self;
}


/*
 
 dict[@"login_name"] = [IVNetworkManager sharedInstance].userInfoModel.loginName;
 dict[@"device_id"] = [UIDevice uuidForDevice];
 dict[@"network_type"] = [UIDevice networkType];
 dict[@"detail"] = @"";

 */

- (void)startAddressIPByService {
    
    
    dispatch_async(_serialQueue, ^{
       
        
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://c01nike.gateway.com/public/app/getClientOutIp"]];
        
        request.HTTPMethod = @"POST";
        
        NSString *bodyStr = @"\"app_token\"=t20bu1y45bcyd9q0jy14qm4x4etxkrijj6f5jpl1sd8y2av14n43hrx5gkwx5jms&signature=2fda4a2d891a9c1fc0b9bcd7d9da59db";
        request.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
        request.timeoutInterval = 20;
        
        NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            
            NSLog(@"error::%@", error);
            NSLog(@"%@", responseObject);
            
        }];
        
        
        [task resume];
        
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

@end



@implementation AnalyzeDataModel



@end

@implementation GatewayDataModel



@end


