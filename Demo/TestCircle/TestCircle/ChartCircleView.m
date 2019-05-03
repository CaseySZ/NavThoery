//
//  CircleView.m
//  TestCircle
//
//  Created by Casey on 21/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

#import "ChartCircleView.h"
#import <CoreGraphics/CoreGraphics.h>
#import "ChartDrawOperation.h"





@implementation ChartCircleView


static NSOperationQueue *__operationQueue;

+ (void)initialize{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __operationQueue = [[NSOperationQueue alloc] init];
        __operationQueue.maxConcurrentOperationCount = 3;
    });
}


- (void)setDataArr:(NSArray<CircleInfoModel *> *)dataArr{
    
    
    _dataArr = dataArr;
    
    ChartDrawOperation *operation = [ChartDrawOperation new];
    operation.view = self;
    operation.dataArr = dataArr;
    [__operationQueue addOperation:operation];
    
}


- (void)drawCircle {


    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    [self handleContext:context];
    
    CGImageRef imageRef =  CGBitmapContextCreateImage(context);
    self.layer.contents = (__bridge id)imageRef;
    
    UIGraphicsEndImageContext();
    CFRelease(imageRef);
}


- (void)handleContext:(CGContextRef)context {
    
    
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, 1);
    
    
    
    CGContextSetStrokeColorWithColor(context, UIColor.blueColor.CGColor);
    CGContextAddArc(context, 10, 10, 9, 0, M_PI*2, 0);
    CGContextStrokePath(context);
   
    
    CGContextSetStrokeColorWithColor(context, UIColor.redColor.CGColor);
    CGContextAddArc(context, 10, 20+10, 9, 0, M_PI*2, 0);
    CGContextStrokePath(context);
    
    
    CGPoint startPointLine = CGPointMake(0, 20+10+10);
    CGPoint endPointLine = CGPointMake(10 + 10, 20);
    
    CGPoint points[2] = {startPointLine, endPointLine};
    CGContextAddLines(context, points, 2);
    CGContextStrokePath(context);
    
    
    
    CGContextDrawPath(context, kCGPathStroke);
    
    
    CGContextRestoreGState(context);
    
    
    
}



@end
