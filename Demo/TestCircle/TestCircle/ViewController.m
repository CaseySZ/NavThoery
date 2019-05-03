//
//  ViewController.m
//  TestCircle
//
//  Created by Casey on 21/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

#import "ViewController.h"
#import "ChartCircleView.h"

@interface ViewController (){
    
    
    ChartCircleView *_circleView;
    
    ChartCircleView *_circleViewTwo;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.lightGrayColor;
    
    
    _circleView = [[ChartCircleView alloc] initWithFrame:CGRectMake(0, 100, 375, 200)];
    _circleView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_circleView];
    
    
    _circleViewTwo = [[ChartCircleView alloc] initWithFrame:CGRectMake(0, 350, 375, 200)];
    _circleViewTwo.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_circleViewTwo];
    
    
    CGFloat radius = 10*UIScreen.mainScreen.scale;
    
    CircleInfoModel *oneModel = [CircleInfoModel new];
    oneModel.color = [UIColor blueColor];
    oneModel.radius = radius;
    oneModel.x = radius;
    oneModel.y = radius;
    
    
    CircleInfoModel *twoModel = [CircleInfoModel new];
    twoModel.color = [UIColor redColor];
    twoModel.radius = radius;
    twoModel.x = radius;
    twoModel.y = radius + radius*2;
    twoModel.startLinePoint = CGPointMake(twoModel.x - radius, twoModel.y + radius);
    twoModel.endLinePoint = CGPointMake(twoModel.x + radius, twoModel.y - radius);
    
    CircleInfoModel *threeModel = [CircleInfoModel new];
    threeModel.color = [UIColor redColor];
    threeModel.radius = radius;
    threeModel.x = radius + radius*2;
    threeModel.y = radius;
    threeModel.startLinePoint = CGPointMake(threeModel.x - radius, threeModel.y + radius);
    threeModel.endLinePoint = CGPointMake(threeModel.x + radius, threeModel.y - radius);
    
    
    NSArray *arr = @[oneModel, twoModel, threeModel];
    
    _circleViewTwo.dataArr = arr;
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    [_circleView drawCircle];
    
    
}



@end
