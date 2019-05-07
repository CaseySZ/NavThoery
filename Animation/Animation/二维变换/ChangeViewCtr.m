//
//  ChangeViewCtr.m
//  Animation
//
//  Created by Casey on 07/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import "ChangeViewCtr.h"

@interface ChangeViewCtr (){
    
    
    IBOutlet UIView *_contentView;
    
}

@end

@implementation ChangeViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *transformBt = [[UIBarButtonItem alloc] initWithTitle:@"transform" style:UIBarButtonItemStylePlain target:self action:@selector(transform)];
    UIBarButtonItem *scaleBt = [[UIBarButtonItem alloc] initWithTitle:@"Scale" style:UIBarButtonItemStylePlain target:self action:@selector(scale)];
    UIBarButtonItem *translationBt = [[UIBarButtonItem alloc] initWithTitle:@"Translation" style:UIBarButtonItemStylePlain target:self action:@selector(translation)];
     UIBarButtonItem *mixtureBt = [[UIBarButtonItem alloc] initWithTitle:@"Mixture" style:UIBarButtonItemStylePlain target:self action:@selector(mixture)];
    UIBarButtonItem *mixtureConcatBt = [[UIBarButtonItem alloc] initWithTitle:@"mixCon" style:UIBarButtonItemStylePlain target:self action:@selector(mixtureConcat)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:transformBt, scaleBt, translationBt, mixtureBt, mixtureConcatBt, nil];
    
}



- (void)transform {
    
    _contentView.transform = CGAffineTransformMakeRotation(M_PI_4);

}

- (void)scale {
    
    _contentView.transform = CGAffineTransformMakeScale(1.5, 1);
}

- (void)translation {
    
    _contentView.transform = CGAffineTransformMakeTranslation(100, 0);
    
}

/*
 前面三个transform变换，对frame并没有相互影响
 原因：frame 是根据bounds，position和transform计算而来
 */


/* 混合变换
 先缩小50%，再旋转30度，最后向右移动200个像素.
 注意：view向右边发生了平移，但并没有指定距离那么远（200像素）。原因在于当你按顺序做了变换，上一个变换的结果将会影响之后的变换，所以200像素的向右平移同样也被旋转了30度，缩小了50%，所以它实际上是斜向移动了100像素
 */
- (void)mixture{
    
    
    CGAffineTransform transform = CGAffineTransformIdentity; // 单位矩阵
    transform = CGAffineTransformScale(transform, 0.5, 0.5);
    transform = CGAffineTransformRotate(transform, M_PI / 180.0 * 30.0);
    transform = CGAffineTransformTranslate(transform, 200, 100);

    _contentView.transform = transform;
    
}

/*

 需要混合两个已经存在的变换矩阵，在两个变换的基础上创建一个新的变换，可以直接使用 CGAffineTransformConcat
 
*/
- (void)mixtureConcat{
    
    
    CGAffineTransform transformOne = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
    CGAffineTransform transformTwo = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI / 180.0 * 30.0);
    CGAffineTransform transform = CGAffineTransformConcat(transformOne, transformTwo);
    
    _contentView.transform = transform;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
   
    _contentView.transform = CGAffineTransformIdentity;
    
}

@end
