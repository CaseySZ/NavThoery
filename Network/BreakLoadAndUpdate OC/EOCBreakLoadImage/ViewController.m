//
//  ViewController.m
//  EOCBreakLoadImage
//
//  Created by EOC on 2017/6/13.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "ViewController.h"
#import "BreakLoadVC.h"
#import "BreakLoadOptVC.h"
#import "EOCUpdateFileVCtr.h"
#import "SysLoadVC.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>{
    
 
}


@end


@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@", docPath);
    
  

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"breadLoad";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"BreakLoadOptimize";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"SysLoad";
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"update";
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        [self.navigationController pushViewController:[BreakLoadVC new] animated:YES];
    }
    if (indexPath.row == 1) {
        
        [self.navigationController pushViewController:[BreakLoadOptVC new] animated:YES];
    }
    if (indexPath.row == 2) {
        
        [self.navigationController pushViewController:[SysLoadVC new] animated:YES];
    }
    if (indexPath.row == 3) {
        
        EOCUpdateFileVCtr *eocBreadLoadVCtr = [EOCUpdateFileVCtr new];
        [self.navigationController pushViewController:eocBreadLoadVCtr animated:YES];
    }
    
}



@end
