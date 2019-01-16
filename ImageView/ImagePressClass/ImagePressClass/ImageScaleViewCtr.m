//
//  ImageScaleViewCtr.m
//  ImagePressClass
//
//  Created by EOC on 2017/4/16.
//  Copyright © 2017年   All rights reserved.
//

#import "ImageScaleViewCtr.h"

@interface ImageScaleViewCtr ()<UIScrollViewDelegate>{
    
    float _preScal;
}

@end

@implementation ImageScaleViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缩放";
    
//    _scrollview.maximumZoomScale = 5;
//    _scrollview.minimumZoomScale = 0.5;
    
    [self eocScale];
}

- (void)eocScale{
    
    //UIPanGestureRecognizer;
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandel:)];
    [_scrollview addGestureRecognizer:pinchGesture];
    
}

- (void)pinchHandel:(UIPinchGestureRecognizer*)gesture{
    
    NSLog(@"%f", gesture.scale);
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _preScal = 1;
    }
    float scaleF = gesture.scale - _preScal + 1;
    _preScal = gesture.scale;
    _imageView.transform = CGAffineTransformScale(_imageView.transform, scaleF, scaleF);
    [_scrollview setContentSize:_imageView.frame.size];
    
    
    
    
}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return _imageView;
    
}





@end
