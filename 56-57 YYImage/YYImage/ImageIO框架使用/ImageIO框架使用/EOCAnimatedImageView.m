//
//  EOCAnimatedImageView.m
//  ImageIO框架使用
//
//  Created by 八点钟学院 on 2017/7/27.
//  Copyright © 2017年 八点钟学院. All rights reserved.
//

#import "EOCAnimatedImageView.h"
#import "EOCImageCoder.h"

typedef NS_ENUM(NSUInteger, EOCAnimatedImageType) {
    EOCAnimatedImageTypeNone = 0,
    EOCAnimatedImageTypeImage,
    EOCAnimatedImageTypeHighlightedImage,
    EOCAnimatedImageTypeImages,
    EOCAnimatedImageTypeHighlightedImages,
};

@interface EOCAnimatedImageView () {
    @package
    UIImage <EOCAnimatedImage> *_curAnimatedImage;
    
    dispatch_semaphore_t _lock; ///< lock for _buffer
    NSOperationQueue *_requestQueue; ///< image request queue, serial
    
    CADisplayLink *_link; ///< ticker for change frame
    NSTimeInterval _time; ///< time after last frame
    
    UIImage *_curFrame; ///< current frame to display
    NSUInteger _curIndex; ///< current frame index (from 0)
    NSUInteger _totalFrameCount; ///< total frame count
    
    BOOL _loopEnd; ///< whether the loop is end.
    NSUInteger _curLoop; ///< current loop count (from 0)
    NSUInteger _totalLoop; ///< total loop count, 0 means infinity
    
    NSMutableDictionary *_buffer; ///< frame buffer
    BOOL _bufferMiss; ///< whether miss frame on last opportunity
    NSUInteger _maxBufferCount; ///< maximum buffer count
    NSInteger _incrBufferCount; ///< current allowed buffer count (will increase by step)
    
    CGRect _curContentsRect;
    BOOL _curImageHasContentsRect; ///< image has implementated "animatedImageContentsRectAtIndex:"
}

@end

@implementation EOCAnimatedImageView

- (instancetype)init {
    
    self = [super init];
    _runloopMode = NSRunLoopCommonModes;
    _autoPlayAnimatedImage = YES;
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    _runloopMode = NSRunLoopCommonModes;
    _autoPlayAnimatedImage = YES;
    return self;
    
}

- (instancetype)initWithImage:(UIImage *)image {
    
    self = [super initWithImage:image];
    _runloopMode = NSRunLoopCommonModes;
    _autoPlayAnimatedImage = YES;
    self.image = image;
    self.frame =  (CGRect){CGPointZero, image.size};
    return self;
    
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    self = [super init];
    _runloopMode = NSRunLoopCommonModes;
    _autoPlayAnimatedImage = YES;
    CGSize size = image ? image.size : highlightedImage.size;
    self.frame = (CGRect) {CGPointZero, size };
    self.image = image;
    self.highlightedImage = highlightedImage;
    return self;
}

//init the animated images
- (void)resetImages {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _lock = dispatch_semaphore_create(1);
        _buffer = [NSMutableDictionary new];
        _requestQueue = [[NSOperationQueue alloc] init];
        _requestQueue.maxConcurrentOperationCount = 1;
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(step:)];
        if (_runloopMode) {
            [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:_runloopMode];
        }
        _link.paused = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    });
    
    [_requestQueue cancelAllOperations];
    
    dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER);
    if (_buffer.count) {
        
        NSMutableDictionary *holder = _buffer;
        _buffer = [NSMutableDictionary new];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            [holder class];
            
        });

    }
    dispatch_semaphore_signal(self->_lock);
    _link.paused = YES;
    _time = 0;
    if (_curIndex != 0) {
        
        [self willChangeValueForKey:@"currentAnimatedImageIndex"];
        _curIndex = 0;
        [self didChangeValueForKey:@"currentAnimatedImageIndex"];
        
    }
    _curAnimatedImage = nil;
    _curFrame = nil;
    _curLoop = 0;
    _totalLoop = 0;
    _totalFrameCount = 1;
    _loopEnd = NO;
    _bufferMiss = NO;
    _incrBufferCount = 0;
    
}

- (void)setImage:(UIImage *)image {
    
    if (self.image == image) return;
    
}

- (void)setHighlightedImage:(UIImage *)highlightedImage {
    
    if (self.highlightedImage == highlightedImage) return;
}

- (void)setAnimationImages:(NSArray<UIImage *> *)animationImages {
    if (self.animationImages == animationImages) return;
    
}

- (void)setHighlightedAnimationImages:(NSArray<UIImage *> *)highlightedAnimationImages {
    
    if (self.highlightedAnimationImages == highlightedAnimationImages) return;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
}

- (EOCAnimatedImageType)currentImageType {
    EOCAnimatedImageType curType = EOCAnimatedImageTypeNone;
    if (self.highlighted) {
        if (self.highlightedAnimationImages.count) curType = EOCAnimatedImageTypeHighlightedImages;
        else if (self.highlightedImage) curType = EOCAnimatedImageTypeHighlightedImage;
    }
    
    if (curType == EOCAnimatedImageTypeNone) {
        if (self.animationImages.count) curType = EOCAnimatedImageTypeImages;
        else if (self.image) curType = EOCAnimatedImageTypeImage;
    }
    return curType;
}

- (void)setImage:(id)image withType:(EOCAnimatedImageType)type {
    
    [self stopAnimating];
    switch (type) {
        case EOCAnimatedImageTypeNone:
            break;
            case EOCAnimatedImageTypeImage:
            super.image = image;
            break;
            case EOCAnimatedImageTypeHighlightedImage:
            super.highlightedImage = image;
            break;
            case EOCAnimatedImageTypeImages:
            super.animationImages = image;
            break;
            case EOCAnimatedImageTypeHighlightedImages:
            super.highlightedAnimationImages = image;
        default:
            break;
    }
}

- (void)imageChanged {
    
    EOCAnimatedImageType newType = [self currentImageType];
    NSUInteger newImageFrameCount = 0;
    BOOL hasContentsRect = NO;
    
    
}
@end
