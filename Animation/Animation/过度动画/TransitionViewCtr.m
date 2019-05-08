//
//  TransitionViewCtr.m
//  Animation
//
//  Created by Casey on 08/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import "TransitionViewCtr.h"

@interface TransitionViewCtr (){
    
    
    IBOutlet UIImageView *_imageView;
}

@end

@implementation TransitionViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIBarButtonItem *fadeBt = [[UIBarButtonItem alloc] initWithTitle:@"Fade" style:UIBarButtonItemStylePlain target:self action:@selector(fade)];
    UIBarButtonItem *moveInBt = [[UIBarButtonItem alloc] initWithTitle:@"moveIn" style:UIBarButtonItemStylePlain target:self action:@selector(moveIn)];
    UIBarButtonItem *pushBt = [[UIBarButtonItem alloc] initWithTitle:@"push" style:UIBarButtonItemStylePlain target:self action:@selector(push)];
    UIBarButtonItem *revealBt = [[UIBarButtonItem alloc] initWithTitle:@"reveal" style:UIBarButtonItemStylePlain target:self action:@selector(reveal)];
    UIBarButtonItem *viewBt = [[UIBarButtonItem alloc] initWithTitle:@"view" style:UIBarButtonItemStylePlain target:self action:@selector(viewAn)];
    UIBarButtonItem *otherBt = [[UIBarButtonItem alloc] initWithTitle:@"other" style:UIBarButtonItemStylePlain target:self action:@selector(transitionDefine)];
    UIBarButtonItem *defineBt = [[UIBarButtonItem alloc] initWithTitle:@"define" style:UIBarButtonItemStylePlain target:self action:@selector(defineTransition)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:fadeBt,moveInBt,pushBt, revealBt,viewBt, otherBt, defineBt, nil];
    
    
}


- (void)fade{
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    
    [_imageView.layer addAnimation:transition forKey:nil];
    
    _imageView.image = [UIImage imageNamed:@"2.png"];
    
}

- (void)moveIn{
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;
    [_imageView.layer addAnimation:transition forKey:nil];
    _imageView.image = [UIImage imageNamed:@"2.png"];
    
}

- (void)push{
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [_imageView.layer addAnimation:transition forKey:nil];
    
    _imageView.image = [UIImage imageNamed:@"2.png"];
    
}

- (void)reveal{
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionReveal;
    [_imageView.layer addAnimation:transition forKey:nil];

    _imageView.image = [UIImage imageNamed:@"2.png"];

   
}


- (void)viewAn {
    
    UIView *redView = [[UIView alloc] initWithFrame:self.view.bounds];
    redView.backgroundColor = UIColor.redColor;
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    transition.duration = 2;
    [self.view.layer addAnimation:transition forKey:nil];
    [self.view addSubview:redView];
    
    
}

/*
 CATransition提供得比较少，其他渡过方式
 */
- (void)transitionDefine {


    [UIView transitionWithView:_imageView duration:2.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{

        self->_imageView.image = [UIImage imageNamed:@"2.png"];

    } completion:^(BOOL finished) {

    }];


}


- (void)transitionDefineT {
    
    UIView *redView = [[UIView alloc] initWithFrame:self.view.bounds];
    redView.backgroundColor = UIColor.redColor;
   
    /*
     fromView 从 superview移除，
     toView 从添加到superView
     */
    [UIView transitionFromView:self.view toView:redView duration:2 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
        
    }];
}


// 自定义
- (void)defineTransition
{
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 截图
    UIImage *coverImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIImageView *coverView = [[UIImageView alloc] initWithImage:coverImage];
    coverView.frame = self.view.bounds;
    [self.view addSubview:coverView];
    
    
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
   
    
    [UIView animateWithDuration:1.0 animations:^{
        
        
        CGAffineTransform transform = CGAffineTransformMakeScale(0.01, 0.01);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        coverView.transform = transform;
        coverView.alpha = 0.0;
        
        
    } completion:^(BOOL finished) {
        
        
        [coverView removeFromSuperview]; // 移除截图
        
    }];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    _imageView.image = [UIImage imageNamed:@"1.png"];
    
}

@end
