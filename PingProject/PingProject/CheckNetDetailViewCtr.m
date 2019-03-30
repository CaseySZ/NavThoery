//
//  CheckDetailViewCtr.m
//  PingProject
//
//  Created by Casey on 30/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import "CheckNetDetailViewCtr.h"
#import "NewPNetPing.h"
#import "NetGatewayAnalyze.h"

@interface CheckNetDetailViewCtr ()<NewPNetPingDelegate>{
    
    IBOutlet UITextView *_textView;
    
    NewPNetPing *_netPing;
    
    NSString *_boundaryString;
}

@end

@implementation CheckNetDetailViewCtr

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"网络诊断";
    self.view.backgroundColor = UIColor.blackColor;
    
    _boundaryString = @"--------------------------------";
    [self checkNetDetail];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [_netPing stopPing];
    
}

- (void)checkNetDetail{
    
    [[NetGatewayAnalyze new] checkGateway:@[@"https//232r.cet.c", @"http://www.bejson.com", @"http://www.baidu.com"] progress:^(AnalyzeDataModel *dataModel) {
        
        
        [self outputGatewayLog:dataModel];
        
    } completion:^(NSArray<AnalyzeDataModel *> *analyzeArr) {
        
       
        [self pingNetOperation];
        
    }];
    
}

- (void)outputGatewayLog:(AnalyzeDataModel*)model {
    
    
    _textView.text = [_textView.text stringByAppendingFormat:@"%@\n", _boundaryString];
    
    _textView.text = [_textView.text stringByAppendingFormat:@"start check gateway... \n"];
    _textView.text = [_textView.text stringByAppendingFormat:@"%@ \n", model.gatewayUrl];
    if (model.timeDuration == FailSpeedCode) {
        
        _textView.text = [_textView.text stringByAppendingFormat:@"check gateway fail code:%@\n", @(model.errorCode)];
        _textView.text = [_textView.text stringByAppendingFormat:@"net type:%@\n", model.networkType];
        _textView.text = [_textView.text stringByAppendingFormat:@"error:%@\n", model.detail];
        
    }else {
        
        _textView.text = [_textView.text stringByAppendingFormat:@"check gateway success\n"];
        _textView.text = [_textView.text stringByAppendingFormat:@"time:%dms\n", (int)model.timeDuration];
        
    }
}


- (void)pingNetOperation {
    
    _netPing = [[NewPNetPing alloc] init];
    _netPing.delegate = self;
    NSString *domainUrl = @"www.baidu.com";
    [_netPing runWithHostName:domainUrl normalPing:YES];
    
    _textView.text = [_textView.text stringByAppendingFormat:@"%@\n", _boundaryString];
    _textView.text = [_textView.text stringByAppendingFormat:@"\n start ping %@ \n\n", domainUrl];
}


- (IBAction)saveToAlbum:(UIButton*)sender {
    
    UIGraphicsBeginImageContext(UIScreen.mainScreen.bounds.size);   //self为需要截屏的UI控件 即通过改变此参数可以截取特定的UI控件
    [UIApplication.sharedApplication.delegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //把图片保存在本地
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}



#pragma mark - NewPNetPingDelegate
- (void)appendPingLog:(NSString *)pingLog{
    
    
}

// 响应时长回调，单位是: ms 毫秒
- (void)appendPingLog:(NSString *)pingLog responseSecond:(long)secon {
    
    NSLog(@"cc:%@, %ld", pingLog, secon);
    _textView.text = [_textView.text stringByAppendingFormat:@"%@  time=%ld\n", pingLog, secon];
}

- (void)netPingDidEnd {
    
    NSLog(@"netPingDidEnd");
    _textView.text = [_textView.text stringByAppendingString:@"\n complete"];
}


#pragma mark - 相册图片保存
- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void*) contextInfo{
    
    NSString *msg = nil;
    
    if(error != NULL){
        
        msg = @"保存图片失败";
        
    }else{
        
        msg = @"保存图片成功";
        
    }
    
}

@end
