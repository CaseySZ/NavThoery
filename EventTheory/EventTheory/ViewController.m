//
//  ViewController.m
//  EventTheory
//
//  Created by sy on 2018/7/18.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "ViewController.h"
#import "SYEventTheoryVC.h"
#import "GestureViewCtr.h"
#import "SYButton.h"
#import "MultiEventViewCtr.h"
#import "ConflictViewCtr.h"
#import "ButtonAndTapVC.h"
#import "ScrollerVCtr.h"
#import "GestureCoexistVCtr.h"
#import "FrameViewCtr.h"



@interface ViewController (){
    
    SYButton *_button;
    SYEventTheoryVC *_reponseChainTest;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
   // [self buttonEventTheory];

}

// button事件原理
- (void)buttonEventTheory{
    
    _button = [[SYButton alloc] initWithFrame:CGRectMake(50, 100, 200, 200)];
    [_button addTarget:self action:@selector(buttonPressOne:) forControlEvents:UIControlEventTouchUpInside];
    [_button addTarget:self action:@selector(buttonPressTwo:) forControlEvents:UIControlEventTouchDown];
    [_button addTarget:self action:@selector(buttonPressThree:) forControlEvents:UIControlEventTouchDragInside];
    
    _button.backgroundColor = [UIColor redColor];
    [self.view addSubview:_button];
    
}


- (void)buttonPressOne:(UIButton*)sender{
    
    NSLog(@"UIControlEventTouchUpInside");
    
}

- (void)buttonPressTwo:(UIButton*)sender{
    
    NSLog(@"UIControlEventTouchDown");
}

- (void)buttonPressThree:(UIButton*)sender{
    
    NSLog(@"UIControlEventTouchDragInside");
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
     [self.navigationController pushViewController:[MultiEventViewCtr new] animated:YES];
    
}


@end
