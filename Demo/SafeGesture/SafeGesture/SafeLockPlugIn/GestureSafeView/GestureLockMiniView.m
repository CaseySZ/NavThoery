//
//  GestureLockSaveView.m
//  SafeGesture
//
//  Created by Casey on 02/02/2019.
//  Copyright © 2019 n. All rights reserved.
//

#import "GestureLockMiniView.h"


@interface GestureLockMiniView  ()

@property (nonatomic, strong) NSMutableArray *buttonArr;


@end



@implementation GestureLockMiniView


+ (instancetype)instance {
    
    GestureLockMiniView *gestureView = [[GestureLockMiniView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    return gestureView;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
       
        self.buttonArr = [NSMutableArray array];
        
        for (int i = 0; i < 9; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.userInteractionEnabled = NO;
            [button setImage:[UIImage imageNamed:@"gesture_indicator_normal"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"gesture_indicator_selected"] forState:UIControlStateSelected];
            [self addSubview:button];
            [self.buttonArr addObject:button];
        }
        
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    int rowMax = 3;//总列数
    
    CGFloat buttonWidth = 9;
    CGFloat buttonHeight = 9;
    
    CGFloat buttonGap = (self.bounds.size.width - rowMax * buttonWidth) / (rowMax + 1);//间距
    
    for (int i = 0; i < self.buttonArr.count; i++) {
        
        int col = i%rowMax; // 列
        int row = i/rowMax; // 行
        CGFloat x = buttonGap + (buttonWidth + buttonGap)*col;
        CGFloat y = buttonGap + (buttonHeight + buttonGap)*row;
        UIButton *btn = self.buttonArr[i];
        btn.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
    }
}

- (void)setGesturesPassword:(NSString *)gesturesPassword{
    
    if (self.hidden == YES) {
        return;
    }
    
    for (UIButton *button in self.buttonArr) {
        button.selected = NO;
    }
    
    for (int i = 0; i < gesturesPassword.length; i++) {
        
        NSInteger index = [gesturesPassword substringWithRange:NSMakeRange(i, 1)].integerValue;
        if (index < self.buttonArr.count) {
            [self.buttonArr[index] setSelected:YES];
        }
        
    }
}





@end
