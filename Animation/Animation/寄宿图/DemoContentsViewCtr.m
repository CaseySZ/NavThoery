//
//  DemoContentsViewCtr.m
//  Animation
//
//  Created by Casey on 06/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import "DemoContentsViewCtr.h"

@interface DemoContentsViewCtr (){
    
    UIView *_contentView;
    
    IBOutlet UIView *_bgView;
    IBOutlet UIView *_oneView;
    IBOutlet UIView *_twoView;
    IBOutlet UIView *_threeView;
    IBOutlet UIView *_fourView;
}

@end

@implementation DemoContentsViewCtr

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"Demo";
    
    
    UIBarButtonItem *propertyBt = [[UIBarButtonItem alloc] initWithTitle:@"property" style:UIBarButtonItemStylePlain target:self action:@selector(property)];
    UIBarButtonItem *componentBt = [[UIBarButtonItem alloc] initWithTitle:@"component" style:UIBarButtonItemStylePlain target:self action:@selector(component)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:propertyBt, componentBt, nil];

    
}


- (void)property {
    
    UIImage *image = [UIImage imageNamed:@"2.png"];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(50, 200, 300, 300)];
    // _contentView.backgroundColor = UIColor.blueColor;
    
    _contentView.layer.contents = (__bridge id)image.CGImage;
    
    // _contentView.contentMode = UIViewContentModeScaleAspectFit;
    //  _contentView.layer.contentsGravity = kCAGravityResizeAspect;
    // _contentView.layer.contentsGravity  = kCAGravityCenter;
    //  _contentView.layer.contentsGravity = kCAGravityResizeAspectFill;
    [self.view addSubview:_contentView];
    
    /*
     contentMode 对应CALayer的属性是contentsGravity， 但是它是一个NSString类型，而不是像对应的UIKit部分，那里面的值是枚举
     目的是为了决定内容在图层的边界中怎么对齐
     */
    
    _contentView.layer.contentsScale = UIScreen.mainScreen.scale;
    /*
     contentsScale属性定义了寄宿图的像素尺寸和视图大小的比例，默认情况下它是一个值为1.0的浮点数。
     他其实属于支持高分辨率（又称Hi-DPI或Retina）屏幕机制的一部分，如果contentsScale设置为1.0，将会以每个点1个像素绘制图片，
     如果设置为2.0，则会以每个点2个像素绘制图片，这就是我们熟知的Retina屏幕
     */
    
    
   // _contentView.layer.masksToBounds = YES;
    /*
     UIView的clipsToBounds属性可以用来决定是否显示超出边界的内容，CALayer对应的属性叫做masksToBounds
     */
    
}

/*
 contentsRect 图片拼合 的用法,指定显示的部分 （矢量图加载可以这么操作）
 */
- (void)component {
    
    UIImage *image = [UIImage imageNamed:@"2.png"];
    
    [self addImage:image withContentRect:CGRectMake(0, 0, 0.5, 0.5) ￼toLayer:_oneView.layer];
    [self addImage:image withContentRect:CGRectMake(0.5, 0, 0.5, 0.5) ￼toLayer:_twoView.layer];
    [self addImage:image withContentRect:CGRectMake(0, 0.5, 0.5, 0.5) ￼toLayer:_threeView.layer];
    [self addImage:image withContentRect:CGRectMake(0.5, 0.5, 0.5, 0.5) ￼toLayer:_fourView.layer];
    
    
}

- (void)addImage:(UIImage *)image withContentRect:(CGRect)rect ￼toLayer:(CALayer *)layer
{
    layer.contents = (__bridge id)image.CGImage;
   // layer.contentsGravity = kCAGravityResizeAspect;
    layer.contentsRect = rect;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    if (_bgView.frame.size.width == 320) {
        
        _bgView.frame = CGRectMake(_bgView.frame.origin.x, _bgView.frame.origin.y, 300, 300);
        
    }else {
        
        _bgView.frame = CGRectMake(_bgView.frame.origin.x, _bgView.frame.origin.y, 320, 320);
    }
}


/*
 小结：寄宿图和一些相关的属性, 和如何显示和放置图片， 和使用拼合技术来显示
 */

@end
