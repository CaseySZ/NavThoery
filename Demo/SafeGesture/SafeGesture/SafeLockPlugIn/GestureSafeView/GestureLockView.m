//
//  GestureLockView.m
//  SafeGesture
//
//  Created by Casey on 01/02/2019.
//  Copyright © 2019 n. All rights reserved.
//

#import "GestureLockView.h"
#import "GestureLockMiniView.h"


#define GestureSafePasswordSaveKey @"ed1#@!z2dkge3az1"

@interface GestureLockView (){
    
    CGPoint _currentPoint;
}

@property (nonatomic, strong)NSString *firstDrawResultText;
@property (nonatomic, strong)GestureLockMiniView *miniLockView;
@property (nonatomic, strong)UIImageView *logImageView;
@property (nonatomic, strong)UILabel *implyLabel;
@property (nonatomic, strong)NSMutableArray *selectedBtns;
@property (nonatomic, assign)int errorCount;

@end


@implementation GestureLockView



#define ButtonStartTag  10010

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        
        _selectedBtns = [NSMutableArray arrayWithCapacity:9];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureEvent:)];
        [self addGestureRecognizer:panGesture];
        
        for (int i = 0; i < 9; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.userInteractionEnabled = NO;
            [button setImage:[UIImage imageNamed:@"gesture_normal"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"gesture_selected"] forState:UIControlStateSelected];
            button.tag = ButtonStartTag + i;
            [self addSubview:button];
            
        }
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.opaque = NO;
        
        _selectedBtns = [NSMutableArray arrayWithCapacity:9];
        self.errorCount = 3;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureEvent:)];
        [self addGestureRecognizer:panGesture];
        
        for (int i = 0; i < 9; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.userInteractionEnabled = NO;
            [button setImage:[UIImage imageNamed:@"gesture_normal"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"gesture_selected"] forState:UIControlStateSelected];
            button.tag = ButtonStartTag + i;
            [self addSubview:button];
            
        }
    
    }
    
    return self;
    
}


- (void)drawRect:(CGRect)rect {
    
    if (self.selectedBtns.count == 0) {
        return;
    }
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    NSInteger selectCount = self.selectedBtns.count;
    for (int i = 0; i < selectCount; i++) {
        
        UIButton *selectButton = self.selectedBtns[i];
        if (i == 0) {
            [linePath moveToPoint:selectButton.center];
        }else {
            [linePath addLineToPoint:selectButton.center];
        }
    }
    [linePath addLineToPoint:_currentPoint];
    
    
    [UIColor.redColor set];
    linePath.lineJoinStyle = kCGLineJoinRound;
    linePath.lineWidth = 4;
    [linePath stroke];
}


- (void)layoutSubviews {
    
    
    [super layoutSubviews];
   
    
    if (self.isSettingLockStyle) {
        
        self.logImageView.hidden = YES;
        self.miniLockView.hidden = NO;
        self.implyLabel.frame = CGRectMake(self.implyLabel.frame.origin.x, CGRectGetMaxY(self.miniLockView.frame) + 28, self.frame.size.width, self.implyLabel.frame.size.height);
        
    }else {
        
        self.logImageView.hidden = NO;
        self.miniLockView.hidden = YES;
        self.implyLabel.frame = CGRectMake(self.implyLabel.frame.origin.x, CGRectGetMaxY(self.logImageView.frame) + 28, self.frame.size.width, self.implyLabel.frame.size.height);
        
    }
    
    
    int rowMax = 3;
    CGFloat buttonWidth = 50;
    CGFloat buttonHeight = 50;
    if (self.frame.size.width > 320) {
        buttonWidth = 62;
        buttonHeight = 62;
    }
    
    CGFloat buttonGap = 34;//(self.frame.size.width - rowMax * buttonWidth)/(rowMax + 1); // 间隔
    CGFloat startX = (self.frame.size.width - (buttonWidth*3 + buttonGap*2))/2;
    CGFloat startY = CGRectGetMaxY(self.implyLabel.frame) + 42;
    
    for (int i = 0; i < 9; i++) {
        
        int col = i%rowMax; // 列
        int row = i/rowMax; // 行
        
        CGFloat x = startX + (buttonWidth + buttonGap)*col;
        CGFloat y = startY + (buttonHeight + buttonGap)*row;
    
        
        UIButton *button = (UIButton*)[self viewWithTag:ButtonStartTag + i];
        button.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
    }
    
    
    
    
}


- (void)setIsSettingLockStyle:(BOOL)isSettingLockStyle {
    
    _isSettingLockStyle = isSettingLockStyle;
    if (_isSettingLockStyle) {
        _implyLabel.text = @"绘制解锁图案";
    }else {
        _implyLabel.text = @"请输入原手势密码";
    }
    [self setNeedsLayout];
    
}


- (BOOL)drawRuleJudge:(NSString*)resultText {
    
    NSString *errorDesc = nil;
    if (resultText.length < 4) {
        errorDesc = @"最少连接4个点，请重新绘制";
    }else {
        [self.miniLockView setGesturesPassword:resultText]; // 四个以上绘制mini图
    }
    
    if (self.isSettingLockStyle) {
        
        if (self.firstDrawResultText != nil &&  ![self.firstDrawResultText isEqualToString:resultText]) {
            errorDesc = @"与上一次绘制不一致, 请重新绘制";
        }
        
    }else {
        
        NSString *pwd =  [[NSUserDefaults standardUserDefaults] objectForKey:GestureSafePasswordSaveKey];
        if (![pwd isEqualToString:resultText]) {
            
            self.errorCount--;
            if (self.errorCount <= 0) {
                errorDesc = @"错误次数已达到上限，请重新登录";
            }else {
                errorDesc = [NSString stringWithFormat:@"密码错误，还可以再输入%d次", self.errorCount];
            }
        }
    }
    

    if (errorDesc.length > 0) {
        
        self.implyLabel.text = errorDesc;
        self.implyLabel.textColor = UIColor.redColor;
        [self shakeAnimationForView:self.implyLabel];
        return NO;
    }
    
    
    return YES;
}

- (void)panGestureEvent:(UIPanGestureRecognizer *)panGesture {
    
    _currentPoint = [panGesture locationInView:self];
    
    
    
    for (int i = 0; i < 9; i++) {
        
        UIButton *button = (UIButton*)[self viewWithTag:ButtonStartTag + i];
        if (CGRectContainsPoint(button.frame, _currentPoint) && button.selected == NO) {
            button.selected = YES;
            [self.selectedBtns addObject:button];
        }
    }
    [self setNeedsLayout];
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        
        
        NSMutableString *gesturePwd = [NSMutableString string];
        for (UIButton *selectButton in self.selectedBtns) {
            [gesturePwd appendFormat:@"%ld",selectButton.tag - ButtonStartTag];
        }
        [self.selectedBtns removeAllObjects];
        
        // 判断手势是否正确
        if(![self drawRuleJudge:gesturePwd]) {
            
            [self clearDrawImage];
            if (self.errorCount <= 0) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(handleError:)]) {
                    [self.delegate handleError:SysSafeErrorCountMax];
                }
            }
            return;
        }
        
        
        if (self.isSettingLockStyle) {
            // 设置手势密码
            if (self.firstDrawResultText == nil) { // 第一次绘制
                
                self.firstDrawResultText = gesturePwd;
                self.implyLabel.text = @"再次绘制解锁图案";
                self.implyLabel.textColor = UIColor.blackColor;
                [self clearDrawImage];
                
                
            }else {
                
                self.implyLabel.text = @"";
                [[NSUserDefaults standardUserDefaults] setObject:gesturePwd forKey:GestureSafePasswordSaveKey];
                if (self.delegate && [self.delegate respondsToSelector:@selector(handleSuccess:)]) {
                    [self.delegate handleSuccess:gesturePwd];
                }
                
            }
            
        }else {
            
            // 解锁密码
            self.implyLabel.text = @"";
            if (self.delegate && [self.delegate respondsToSelector:@selector(handleSuccess:)]) {
                [self.delegate handleSuccess:gesturePwd];
            }

        }
        
        
        
        
    }else {
        
       [self setNeedsDisplay];
    }
    
    
}


- (void)clearDrawImage {
    
    for (int i = 0; i < 9; i++) {
        
        UIButton *button = (UIButton*)[self viewWithTag:ButtonStartTag + i];
        button.selected = NO;
        
    }
    [self setNeedsDisplay];
    
}


//抖动动画
- (void)shakeAnimationForView:(UIView *)view{
    
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - 10, position.y);
    CGPoint right = CGPointMake(position.x + 10, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES]; // 平滑结束
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
}


#pragma mark - 懒加载

- (GestureLockMiniView*)miniLockView {
    
    if (!_miniLockView) {
        _miniLockView = [[GestureLockMiniView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 60/2, 30, 60, 60)];
        [self addSubview:_miniLockView];
    }
    return _miniLockView;

}

- (UILabel*)implyLabel {
    
    
    if (!_implyLabel) {
        
        _implyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90 + 28, self.frame.size.width, 16)];
        _implyLabel.textColor = UIColor.blackColor;
        _implyLabel.text = @"请输入原手势密码";
        _implyLabel.font = [UIFont systemFontOfSize:14];
        _implyLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_implyLabel];
    }
    return _implyLabel;
    
}

- (UIImageView*)logImageView {
    
    if (!_logImageView) {
        _logImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 80/2, 30, 80, 80)];
        _logImageView.image = [UIImage imageNamed:@"safeLockIcon.png"];
        [self addSubview:_logImageView];
    }
    
    return _logImageView;
}


@end
