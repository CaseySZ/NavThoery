//
//  ViewController.m
//  Chats
//
//  Created by sunyong on 14-6-24.
//  Copyright (c) 2014年 sunyong. All rights reserved.
//

#import "ViewController.h"
#import "chatC.h"
#import "chatcUDP.h"

@interface ViewController (){
    chatC *_chatC;
    chatcUDP *_chatcUdp;
}

@end

@implementation ViewController

/*
 IPv4 2*8*4  2*32(42亿)
 IPv6 2*62  
 NSURLSessoion
 
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"=== %d", getpid());
    
//    _chatC = [[chatC alloc] init];
//    [_chatC buildClientChat];
    
    _chatcUdp = [chatcUDP new];
    [_chatcUdp udpClientChat];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //[_chatC sendData:textField.text];
    [_chatcUdp sendData:textField.text];
    return YES;
}



@end
