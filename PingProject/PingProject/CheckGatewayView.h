//
//  CheckGatewayView.h
//  PingProject
//
//  Created by Casey on 30/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CheckGatewayView : UIView



+ (void)showCheck:(NSArray*)gatewayArr diagnose:(void(^)(void))diagnosisEvent;


@end


