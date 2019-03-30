//
//  NetGatewayAnalyze.h
//  PingProject
//
//  Created by Casey on 29/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define FailSpeedCode 20000

@interface GatewayDataModel : NSObject

@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *gatewayUrl;
@property (nonatomic, assign)CGFloat timeDuration;

@property (nonatomic, strong)NSString *networkType;
@property (nonatomic, strong)NSString *deviceId;
@property (nonatomic, strong)NSString *detail;
@property (nonatomic, strong)NSString *loginName;

@end


@interface AnalyzeDataModel : NSObject


@property (nonatomic, strong)NSString *gatewayUrl;
@property (nonatomic, assign)CGFloat timeDuration;
@property (nonatomic, strong)NSString *networkType;
@property (nonatomic, strong)NSString *detail;
@property (nonatomic, assign)NSInteger errorCode; 

@end



@interface NetGatewayAnalyze : NSObject


- (void)startAddressIPByService;
- (void)checkGateway:(NSArray*)gatewayArr progress:(void(^)(AnalyzeDataModel *dataModel))progress completion:(void(^)(NSArray<AnalyzeDataModel*> *analyzeArr))completion;



@end





