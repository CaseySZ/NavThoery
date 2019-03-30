//
//  NewPNetPing.m
//  LDNetCheckServiceDemo
//
//  Created by 庞辉 on 14-10-29.
//  Copyright (c) 2014年 庞辉. All rights reserved.
//
#include <sys/socket.h>
#include <netdb.h>
#include <sys/time.h>

#import "NewPNetPing.h"
#import "NewPSimplePing.h"

#define MAXCOUNT_PING 4

@interface NewPNetPing () <NewPSimplePingDelegate> {

    BOOL _isConnectSuccess; //判断是否能连接到 地址
    NSString *_hostAddress; //目标域名的IP地址
    NSTimer *_pingTimeOutTimer; //
    dispatch_queue_t _serialQueue;

}

@property (nonatomic, strong) NewPSimplePing *pinger;
@property (nonatomic, assign) BOOL isConnectSuccess;
@property (nonatomic, assign) NSInteger sendCount;  //当前执行次数
@property (nonatomic, assign) BOOL isSendLargeDataByPing;
@property (nonatomic, assign) long startPingOperationTime; //每次执行的开始时间

@end


@implementation NewPNetPing
@synthesize pinger = _pinger;



- (instancetype)init {
    
    self = [super init];
    if (self) {
        _serialQueue = dispatch_queue_create("pingOperationQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}




/*
 * 调用pinger解析指定域名
 * @param hostName 指定域名
 */

- (void)runWithHostName:(NSString *)hostName normalPing:(BOOL)normalPing{
    
    
    dispatch_async(_serialQueue, ^{
        
        NSLog(@"dispatch_async c ");
        [self stopPing];
        self.pinger = [[NewPSimplePing alloc] initWithHostName:hostName];
        self.pinger.delegate = self;
        
        self.isSendLargeDataByPing = !normalPing;
        
        
        [self.pinger start];
        
        //在当前线程一直执行
        self.sendCount = 1;
        
        do {
            
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            
        } while (self.pinger != nil || self.sendCount <= MAXCOUNT_PING);
        NSLog(@"finish");
    });
    
    

    
}

/**
 * 停止当前ping动作
 */
- (void)stopPing
{
    [_pingTimeOutTimer invalidate];
    _pingTimeOutTimer = nil;
    
    [self.pinger stop];
    self.pinger = nil;
    _sendCount = MAXCOUNT_PING + 1;
}


/*
 * 发送Ping数据，pinger会组装一个ICMP控制报文的数据发送过去
 *
 */
- (void)exePingAddressOp
{
    if (_pingTimeOutTimer) {
        [_pingTimeOutTimer invalidate];
        _pingTimeOutTimer = nil;
    }
    if (_sendCount > MAXCOUNT_PING) {
        
        [self stopPing];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(netPingDidEnd)]) {
                [self.delegate netPingDidEnd];
            }
            
        });
        
        
    }else {
        
        _sendCount++;
        _startPingOperationTime = [self getMicroSeconds];
        
        if (_isSendLargeDataByPing) {
            
            NSMutableString *largeString = [NSMutableString string];
            for (int i=0; i< 1024; i++) {
                [largeString appendString:@"abcdefghi1234567890"];
            }
            
            NSData *largeData = [largeString dataUsingEncoding:NSASCIIStringEncoding];
            
            [self.pinger sendPingWithData:largeData];
            
        } else {
            
            [self.pinger sendPingWithData:nil];
        }
        
        _pingTimeOutTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                 target:self
                                               selector:@selector(pingTimeoutEvent)
                                               userInfo:nil
                                                repeats:NO];
    }
}

- (void)pingTimeoutEvent
{
    if ( _sendCount <= MAXCOUNT_PING + 1 && _sendCount > 1) {
        
        NSString *timeoutLog = [NSString stringWithFormat:@"ping: cannot resolve %@: TimeOut", _hostAddress];
        if (self.delegate && [self.delegate respondsToSelector:@selector(appendPingLog:)]) {
            [self.delegate appendPingLog:timeoutLog];
        }
        [self exePingAddressOp];
    }
}


#pragma mark - Pingdelegate
/*
 * PingDelegate: 套接口开启之后发送ping数据，并开启一个timer（1s间隔发送数据）
*/

- (void)simplePing:(NewPSimplePing *)pinger didStartWithAddress:(NSData *)address
{

    _hostAddress = [self DisplayAddressForAddress:address];
    _isConnectSuccess = YES;
    [self exePingAddressOp];

}

/*
 * PingDelegate: ping命令发生错误之后，立即停止timer和线程
 *
 */
- (void)simplePing:(NewPSimplePing *)pinger didFailWithError:(NSError *)error
{

    NSString *failCreateLog = [NSString stringWithFormat:@"#%ld try create failed: %@", (long)_sendCount, [self shortErrorFromError:error]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(appendPingLog:)]) {
            [self.delegate appendPingLog:failCreateLog];
        }
        
    });
    

    //如果不是创建套接字失败，都是发送数据过程中的错误,可以继续try发送数据
    if (_isConnectSuccess) {
        [self exePingAddressOp];
    } else {
        [self stopPing];
    }
}

/*
 * PingDelegate: 发送ping数据成功
 *
 */
- (void)simplePing:(NewPSimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber;
{

  //  NSLog(@"#%u sent success",sequenceNumber);
}


/*
 * PingDelegate: 发送ping数据失败
 */
- (void)simplePing:(NewPSimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error
{

    NSString *sendFailLog = [NSString stringWithFormat:@"#%u send failed: %@",sequenceNumber, [self shortErrorFromError:error]];
    //记录
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(appendPingLog:)]) {
            [self.delegate appendPingLog:sendFailLog];
        }
    });
    [self exePingAddressOp];
}


/*
 * PingDelegate: 成功接收到PingResponse数据
 */
- (void)simplePing:(NewPSimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber
{

    //由于IPV6在IPheader中不返回TTL数据，所以这里不返回TTL，改为返回Type
    //http://blog.sina.com.cn/s/blog_6a1837e901012ds8.html
    
    NSString *icmpReplyType = [NSString stringWithFormat:@"%@", [NewPSimplePing icmpInPacket:packet]->type == 129 ? @"ICMPv6TypeEchoReply" : @"ICMPv4TypeEchoReply"];
    long responseSecond = [self computeDurationSince:_startPingOperationTime] / 1000;
    NSString *successLog = [NSString stringWithFormat:@"%lu bytes from %@ icmp_seq=#%u type=%@ time=%ldms", (unsigned long)[packet length], _hostAddress, sequenceNumber, icmpReplyType, responseSecond];
    
    //记录ping成功的数据
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(appendPingLog:)]) {
            [self.delegate appendPingLog:successLog];
        }
        // 响应时长
        if (self.delegate && [self.delegate respondsToSelector:@selector(appendPingLog:responseSecond:)]) {
            [self.delegate appendPingLog:successLog responseSecond:responseSecond];
        }
    });
    [self exePingAddressOp];
}


/*
 * PingDelegate: 接收到错误的pingResponse数据
 */
- (void)simplePing:(NewPSimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet
{
    const ICMPHeader *icmpPtr;
    if (self.pinger && pinger == self.pinger) {
        icmpPtr = [NewPSimplePing icmpInPacket:packet];
        NSString *errorLog = @"";
        if (icmpPtr != NULL) {
            errorLog = [NSString
                stringWithFormat:@"#%u unexpected ICMP type=%u, code=%u, identifier=%u",
                                 (unsigned int)OSSwapBigToHostInt16(icmpPtr->sequenceNumber),
                                 (unsigned int)icmpPtr->type, (unsigned int)icmpPtr->code,
                                 (unsigned int)OSSwapBigToHostInt16(icmpPtr->identifier)];
        } else {
            errorLog = [NSString stringWithFormat:@"#%ld try unexpected packet size=%zu", (long)_sendCount,
                                                  (size_t)[packet length]];
        }
        //记录
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(appendPingLog:)]) {
                [self.delegate appendPingLog:errorLog];
            }
            
        });
    }

    //当检测到错误数据的时候，再次发送
    [self exePingAddressOp];
}

/**
 * 将ping接收的数据转换成ip地址
 * @param address 接受的ping数据
 */
-(NSString *)DisplayAddressForAddress:(NSData *)address
{
    int err;
    NSString *result;
    char hostStr[NI_MAXHOST];
    
    result = nil;
    if (address != nil) {
        err = getnameinfo([address bytes], (socklen_t)[address length], hostStr, sizeof(hostStr),
                          NULL, 0, NI_NUMERICHOST);
        if (err == 0) {
            result = [NSString stringWithCString:hostStr encoding:NSASCIIStringEncoding];
            assert(result != nil);
        }
    }
    
    return result;
}

/*
 * 解析错误数据并翻译
 */
- (NSString *)shortErrorFromError:(NSError *)error
{
    NSString *result;
    NSNumber *failureNum;
    int failure;
    const char *failureStr;
    
    assert(error != nil);
    
    result = nil;
    
    // Handle DNS errors as a special case.
    
    if ([[error domain] isEqual:(NSString *)kCFErrorDomainCFNetwork] &&
        ([error code] == kCFHostErrorUnknown)) {
        failureNum = [[error userInfo] objectForKey:(id)kCFGetAddrInfoFailureKey];
        if ([failureNum isKindOfClass:[NSNumber class]]) {
            failure = [failureNum intValue];
            if (failure != 0) {
                failureStr = gai_strerror(failure);
                if (failureStr != NULL) {
                    result = [NSString stringWithUTF8String:failureStr];
                    assert(result != nil);
                }
            }
        }
    }
    
    // Otherwise try various properties of the error object.
    
    if (result == nil) {
        result = [error localizedFailureReason];
    }
    if (result == nil) {
        result = [error localizedDescription];
    }
    if (result == nil) {
        result = [error description];
    }
    assert(result != nil);
    return result;
}

/**
 * Retourne un timestamp en microsecondes.
 */
- (long)getMicroSeconds
{
    struct timeval time;
    gettimeofday(&time, NULL);
    return time.tv_usec;
}

/**
 * Calcule une durée en millisecondes par rapport au timestamp passé en paramètre.
 */
- (long)computeDurationSince:(long)uTime
{
    long now = [self getMicroSeconds];
    if (now < uTime) {
        return 1000000 - uTime + now;
    }
    return now - uTime;
}


- (void)dealloc{
    
    [self stopPing];
    
}



@end
