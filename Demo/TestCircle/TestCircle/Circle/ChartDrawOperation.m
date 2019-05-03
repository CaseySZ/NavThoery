//
//  ChartDrawOperation.m
//  TestCircle
//
//  Created by Casey on 21/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

#import "ChartDrawOperation.h"
#import <CoreGraphics/CoreGraphics.h>


@interface ChartDrawOperation ()

@property (nonatomic, assign)CGFloat width;
@property (nonatomic, assign)CGFloat height;

@end

@implementation ChartDrawOperation


- (void)main {
    
    
    [self drawCircleChart];
    
}


- (void)setView:(UIView *)view {
    
    _view = view;
    
    self.width = view.frame.size.width;
    self.height = view.frame.size.height;
    
}

- (void)drawCircleChart {
    
    CGFloat scale  = UIScreen.mainScreen.scale;
    CGFloat width = self.width*scale;
    CGFloat height = self.height*scale;
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, width*4, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self handleContext:context];
    
    
    CGImageRef imageRef =  CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
    CFRelease(imageRef);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.view.layer.contents = (__bridge id)image.CGImage;
    });
    
}


- (void)handleContext:(CGContextRef)context {
    
    
    CGFloat scale  = UIScreen.mainScreen.scale;
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1*scale);
    
    
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        
        CircleInfoModel *infoModel = self.dataArr[i];
        
        UIColor *color = infoModel.color;
        
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextAddArc(context, infoModel.x, infoModel.y, infoModel.radius, 0, M_PI*2, 0);
        CGContextStrokePath(context);
        
        if (infoModel.isHaveLine) {
            
            CGPoint startPointLine = infoModel.startLinePoint;
            CGPoint endPointLine = infoModel.endLinePoint;
            CGPoint points[2] = {startPointLine, endPointLine};
            CGContextAddLines(context, points, 2);
            CGContextStrokePath(context);
            
        }
    }
    
    CGContextDrawPath(context, kCGPathStroke);
    CGContextRestoreGState(context);
    
    
}



- (void)dealloc {
    
    NSLog(@"dealloc");
}


@end
