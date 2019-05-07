//
//  TDChangeViewCtr.m
//  Animation
//
//  Created by Casey on 07/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import "TDChangeViewCtr.h"

@interface TDChangeViewCtr (){
    
    
    IBOutlet UIImageView *_imageView;
    
}

@end

@implementation TDChangeViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *transformBt = [[UIBarButtonItem alloc] initWithTitle:@"transform" style:UIBarButtonItemStylePlain target:self action:@selector(transform)];
    UIBarButtonItem *m34Bt = [[UIBarButtonItem alloc] initWithTitle:@"M34" style:UIBarButtonItemStylePlain target:self action:@selector(transformM34)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:transformBt, m34Bt,nil];
    
}

// 旋转 和 2d效果差不多
- (void)transform {
    
    CATransform3D transform = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
    _imageView.layer.transform = transform;
}


/*
 1.1透视投影 (能逼真地反映形体的空间形象, 使观察者获得立体、有深度的空间感觉，就必须研究透视变换的规律, 太专业了)
 且 Core Animation并没有给我们提供设置透视变换的函数，但幸运的是，CATransform3D的透视效果通过一个矩阵中一个很简单的元素来控制：m34（m34用于按比例缩放X和Y的值来计算到底要离视角多远）
 所以 CATransform3D的m34元素，用来做透视。
 
 1.2  m34的默认值是0，我们可以通过设置m34为-1.0 / d来应用透视效果，d代表了想象中视角相机和屏幕之间的距离，以像素为单位， 通常500-1000就可以了
 
*/
- (void)transformM34{
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = - 1.0 / 500.0;
    transform = CATransform3DRotate(transform, M_PI_4, 0, 1, 0);
    _imageView.layer.transform = transform;
}

@end
