//
//  TDDemoViewCtr.m
//  Animation
//
//  Created by Casey on 07/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import "TDDemoViewCtr.h"

@interface TDDemoViewCtr (){
    
    
    IBOutlet UIView *_oneView;
    IBOutlet UIView *_twoView;
    IBOutlet UIView *_threeView;
    IBOutlet UIView *_fourView;
    IBOutlet UIView *_fiveView;
    IBOutlet UIView *_sixView;
    IBOutlet UIView *_contentView;
    NSArray *facesViewArr;
}

@end

@implementation TDDemoViewCtr

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"Demo";
    
    
    facesViewArr = @[_oneView, _twoView, _threeView, _fourView, _fiveView,_sixView];
    [_oneView removeFromSuperview];
    [_twoView removeFromSuperview];
    [_threeView removeFromSuperview];
    [_fourView removeFromSuperview];
    [_fiveView removeFromSuperview];
    [_sixView removeFromSuperview];
    
    CATransform3D perspective = CATransform3DIdentity;
 //   perspective.m34 = -1.0 / 500.0;
    
    /*
     从这个角度看立方体并不是很明显；看起来只是一个方块，为了更好地欣赏它，我们将更换一个不同的视角。
     另一个视角去观察立方体, Y轴旋转45度，并且绕X轴旋转45度的角度
     */
   // perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
  //  perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
    
    /*
     sublayerTransform属性，是CATransform3D类型，但和对一个图层的变换不同，它影响到所有的子图层。这可以一次性对包含这些图层的容器做变换，于是所有的子图层都自动继承了这个变换方法。通过这个属性来调整观察角度
     */
    _contentView.layer.sublayerTransform = perspective;
    
    
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 100);
    [self addFace:0 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(100, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:1 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(0, -100, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:2 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(0, 100, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [self addFace:3 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(-100, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [self addFace:4 withTransform:transform];
   
    transform = CATransform3DMakeTranslation(0, 0, -100);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    [self addFace:5 withTransform:transform];

}


- (void)addFace:(NSInteger)index withTransform:(CATransform3D)transform
{
   
    UIView *face = facesViewArr[index];
    [_contentView addSubview:face];
    CGSize containerSize = _contentView.bounds.size;
    face.center = CGPointMake(containerSize.width / 2.0, containerSize.height / 2.0);
    face.layer.transform = transform;
}


@end
