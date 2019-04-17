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
#import "ChatS.h"

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
    
 //   [NSThread detachNewThreadSelector:@selector(testSerVer) toTarget:self withObject:nil];
    
    
   // _chatC = [[chatC alloc] init];
   // [_chatC buildClientChat];
    

//    _chatcUdp = [chatcUDP new];
//    [_chatcUdp udpClientChat];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    _chatC = [[chatC alloc] init];
    [_chatC buildClientChat];
    
    
}

- (void)testSerVer{
    
    [ChatS chatServer];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //[_chatC sendData:textField.text];
    [_chatC sendData:textField.text];
    return YES;
}



@end
