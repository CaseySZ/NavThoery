//
//  ScrollerVCtr.m
//  EventTheory
//
//  Created by sy on 2018/7/20.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "ScrollerVCtr.h"
#import "SYScrollView.h"

@interface ScrollerVCtr (){
    
    UIScrollView *_scrollview;
}

@end

@implementation ScrollerVCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *imageNameArr = @[@"1", @"2", @"3"];
    
    _scrollview = [[SYScrollView alloc] initWithFrame:CGRectMake(50, 100, self.view.frame.size.width - 50*2, 200)];
    _scrollview.pagingEnabled = YES;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.contentSize = CGSizeMake(_scrollview.frame.size.width*imageNameArr.count, _scrollview.frame.size.height);
    _scrollview.clipsToBounds = NO;
    [self.view addSubview:_scrollview];
    
    
    [self.navigationController.interactivePopGestureRecognizer requireGestureRecognizerToFail:_scrollview.panGestureRecognizer];
    
    for (int i = 0; i < imageNameArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*_scrollview.frame.size.width, 0, _scrollview.frame.size.width-20, _scrollview.frame.size.height)];
        imageView.image = [UIImage imageNamed:imageNameArr[i]];
        [_scrollview addSubview:imageView];
    }
    
}



@end
