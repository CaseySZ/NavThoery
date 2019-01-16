//
//  EOCImageCoder.m
//  ImageIO框架使用
//
//  Created by 八点钟学院 on 2017/7/19.
//  Copyright © 2017年 八点钟学院. All rights reserved.
//

#import "EOCImageCoder.h"
#import <ImageIO/ImageIO.h>
#import <objc/runtime.h>
#import <pthread.h>
#import <zlib.h>

#define EOC_FOUR_CC(c1,c2,c3,c4) ((uint32_t)(((c4) << 24) | ((c3) << 16) | ((c2) << 8) | (c1)))
#define EOC_TWO_CC(c1,c2) ((uint16_t)(((c2) << 8) | (c1)))

static inline uint16_t eoc_swap_endian_uint16(uint16_t value) {
    return
    (uint16_t) ((value & 0x00FF) << 8) |
    (uint16_t) ((value & 0xFF00) >> 8) ;
}

static inline uint32_t eoc_swap_endian_uint32(uint32_t value) {
    return
    (uint32_t)((value & 0x000000FFU) << 24) |
    (uint32_t)((value & 0x0000FF00U) <<  8) |
    (uint32_t)((value & 0x00FF0000U) >>  8) |
    (uint32_t)((value & 0xFF000000U) >> 24) ;
}

CGColorSpaceRef EOCCGColorSpaceGetDeviceRGB() {
    static CGColorSpaceRef space;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        space = CGColorSpaceCreateDeviceRGB();
    });
    return space;
}

CGColorSpaceRef EOCCGColorSpaceGetDeviceGray() {
    static CGColorSpaceRef space;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        space = CGColorSpaceCreateDeviceGray();
    });
    return space;
}

BOOL EOCCGColorSpaceIsDeviceRGB(CGColorSpaceRef space) {
    return space && CFEqual(space, EOCCGColorSpaceGetDeviceRGB());
}

BOOL EOCCGColorSpaceIsDeviceGray(CGColorSpaceRef space) {
    return space && CFEqual(space, EOCCGColorSpaceGetDeviceGray());
}


static void EOCCGDataProviderReleaseDataCallback(void *info, const void *data, size_t size) {
    if (info) free(info);
}

EOCImageType EOCImageDetectType(CFDataRef data) {
    if (!data) return EOCImageTypeUnknown;
    uint64_t length = CFDataGetLength(data);
    if (length < 16) return EOCImageTypeUnknown;
    
    const char *bytes = (char *)CFDataGetBytePtr(data);
    
    uint32_t magic4 = *((uint32_t *)bytes);
    switch (magic4) {
        case EOC_FOUR_CC(0x4D, 0x4D, 0x00, 0x2A): { // big endian TIFF
            return EOCImageTypeTIFF;
        } break;
            
        case EOC_FOUR_CC(0x49, 0x49, 0x2A, 0x00): { // little endian TIFF
            return EOCImageTypeTIFF;
        } break;
            
        case EOC_FOUR_CC(0x00, 0x00, 0x01, 0x00): { // ICO
            return EOCImageTypeICO;
        } break;
            
        case EOC_FOUR_CC(0x00, 0x00, 0x02, 0x00): { // CUR
            return EOCImageTypeICO;
        } break;
            
        case EOC_FOUR_CC('i', 'c', 'n', 's'): { // ICNS
            return EOCImageTypeICNS;
        } break;
            
        case EOC_FOUR_CC('G', 'I', 'F', '8'): { // GIF
            return EOCImageTypeGIF;
        } break;
            
        case EOC_FOUR_CC(0x89, 'P', 'N', 'G'): {  // PNG
            uint32_t tmp = *((uint32_t *)(bytes + 4));
            if (tmp == EOC_FOUR_CC('\r', '\n', 0x1A, '\n')) {
                return EOCImageTypePNG;
            }
        } break;
            
        case EOC_FOUR_CC('R', 'I', 'F', 'F'): { // WebP
            uint32_t tmp = *((uint32_t *)(bytes + 8));
            if (tmp == EOC_FOUR_CC('W', 'E', 'B', 'P')) {
                return EOCImageTypeWebP;
            }
        } break;
            /*
             case YY_FOUR_CC('B', 'P', 'G', 0xFB): { // BPG
             return YYImageTypeBPG;
             } break;
             */
    }
    
    uint16_t magic2 = *((uint16_t *)bytes);
    switch (magic2) {
        case EOC_TWO_CC('B', 'A'):
        case EOC_TWO_CC('B', 'M'):
        case EOC_TWO_CC('I', 'C'):
        case EOC_TWO_CC('P', 'I'):
        case EOC_TWO_CC('C', 'I'):
        case EOC_TWO_CC('C', 'P'): { // BMP
            return EOCImageTypeBMP;
        }
        case EOC_TWO_CC(0xFF, 0x4F): { // JPEG2000
            return EOCImageTypeJPEG2000;
        }
    }
    
    // JPG             FF D8 FF
    if (memcmp(bytes,"\377\330\377",3) == 0) return EOCImageTypeJPEG;
    
    // JP2
    if (memcmp(bytes + 4, "\152\120\040\040\015", 5) == 0) return EOCImageTypeJPEG2000;
    
    return EOCImageTypeUnknown;
}

UIImageOrientation EOCUIImageOrientationFromEXIFValue(NSInteger value) {
    switch (value) {
        case kCGImagePropertyOrientationUp: return UIImageOrientationUp;
        case kCGImagePropertyOrientationDown: return UIImageOrientationDown;
        case kCGImagePropertyOrientationLeft: return UIImageOrientationLeft;
        case kCGImagePropertyOrientationRight: return UIImageOrientationRight;
        case kCGImagePropertyOrientationUpMirrored: return UIImageOrientationUpMirrored;
        case kCGImagePropertyOrientationDownMirrored: return UIImageOrientationDownMirrored;
        case kCGImagePropertyOrientationLeftMirrored: return UIImageOrientationLeftMirrored;
        case kCGImagePropertyOrientationRightMirrored: return UIImageOrientationRightMirrored;
        default: return UIImageOrientationUp;
    }
}

CGImageRef EOCCGImageCreateDecodedCopy(CGImageRef imageRef, BOOL decodeForDisplay) {
    if (!imageRef) return NULL;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    if (width == 0 || height == 0) return NULL;
    
    if (decodeForDisplay) { //decode with redraw (may lose some precision)
        
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
        
        alphaInfo = alphaInfo & kCGBitmapAlphaInfoMask;
        BOOL hasAlpha = NO;
        if (alphaInfo == kCGImageAlphaPremultipliedLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaFirst) {
            hasAlpha = YES;
        }
        // BGRA8888 (premultiplied) or BGRX8888
        // same as UIGraphicsBeginImageContext() and -[UIView drawRect:]
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, EOCCGColorSpaceGetDeviceRGB(), bitmapInfo);
        if (!context) return NULL;
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef); // decode
        CGImageRef newImage = CGBitmapContextCreateImage(context);
        CFRelease(context);
        return newImage;
        
    } else {
        CGColorSpaceRef space = CGImageGetColorSpace(imageRef);
        size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
        size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
        size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
        CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
        if (bytesPerRow == 0 || width == 0 || height == 0) return NULL;
        
        CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
        if (!dataProvider) return NULL;
        CFDataRef data = CGDataProviderCopyData(dataProvider); // decode
        if (!data) return NULL;
        
        CGDataProviderRef newProvider = CGDataProviderCreateWithCFData(data);
        CFRelease(data);
        if (!newProvider) return NULL;
        
        CGImageRef newImage = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, space, bitmapInfo, newProvider, NULL, false, kCGRenderingIntentDefault);
        CFRelease(newProvider);
        return newImage;
    }
}

@implementation EOCImageFrame
+ (instancetype)frameWithImage:(UIImage *)image {
    
    EOCImageFrame *frame = [self new];
    frame.image = image;
    return frame;
}
- (id)copyWithZone:(NSZone *)zone {
    EOCImageFrame *frame = [self.class new];
    frame.index = _index;
    frame.width = _width;
    frame.height = _height;
    frame.offsetX = _offsetX;
    frame.offsetY = _offsetY;
    frame.duration = _duration;
    frame.dispose = _dispose;
    frame.blend = _blend;
    frame.image = _image.copy;
    return frame;
}
@end

@interface _EOCImageDecoderFrame : EOCImageFrame
@property (nonatomic, assign) BOOL hasAlpha;                ///< Whether frame has alpha.
@property (nonatomic, assign) BOOL isFullSize;              ///< Whether frame fill the canvas.
@property (nonatomic, assign) NSUInteger blendFromIndex;    ///< Blend from frame index to current frame.
@end

@implementation _EOCImageDecoderFrame
- (id)copyWithZone:(NSZone *)zone {
    
    _EOCImageDecoderFrame *frame = [super copyWithZone:zone];
    frame.hasAlpha = _hasAlpha;
    frame.isFullSize = _isFullSize;
    frame.blendFromIndex = _blendFromIndex;
    return frame;
}
@end


@implementation EOCImageDecoder {
    pthread_mutex_t _lock; // recursive lock
    
    BOOL _sourceTypeDetected;
    CGImageSourceRef _source;
    UIImageOrientation _orientation;
    dispatch_semaphore_t _framesLock;
    NSArray *_frames; ///< Array<GGImageDecoderFrame>, without image
    BOOL _needBlend;
    NSUInteger _blendFrameIndex;
    CGContextRef _blendCanvas;
}

+ (instancetype)decoderWithData:(NSData *)data scale:(CGFloat)scale {
    
    if (!data) return nil;
    EOCImageDecoder *decoder = [[EOCImageDecoder alloc] initWithScale:scale];
    [decoder updateData:data final:YES];
    if (decoder.frameCount == 0) return nil;
    return decoder;
    
}

- (EOCImageFrame *)frameAtIndex:(NSUInteger)index decodeForDisplay:(BOOL)decodeForDisplay {
    EOCImageFrame *result = nil;
    pthread_mutex_lock(&_lock);
    result = [self _frameAtIndex:index decodeForDisplay:decodeForDisplay];
    pthread_mutex_unlock(&_lock);
    return result;
}

- (EOCImageFrame *)_frameAtIndex:(NSUInteger)index decodeForDisplay:(BOOL)decodeForDisplay {
    
    if (index >= _frames.count) return 0;
    _EOCImageDecoderFrame *frame = [(_EOCImageDecoderFrame *)_frames[index] copy];
    BOOL decoded = NO;
    BOOL extendToCanvas = NO;
    if (_type != EOCImageTypeICO && decodeForDisplay) { // ICO contains multi-size frame and should not extend to canvas.
        extendToCanvas = YES;
    }
    
    if (!_needBlend) {
        CGImageRef imageRef = [self _newUnblendedImageAtIndex:index extendToCanvas:extendToCanvas decoded:&decoded];
        if (!imageRef) return nil;
        if (decodeForDisplay && !decoded) {
            CGImageRef imageRefDecoded = EOCCGImageCreateDecodedCopy(imageRef, YES);
            if (imageRefDecoded) {
                CFRelease(imageRef);
                imageRef = imageRefDecoded;
                decoded = YES;
            }
        }
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:_scale orientation:_orientation];
        CFRelease(imageRef);
        if (!image) return nil;
        image.eoc_isDecodedForDisplay = decoded;
        frame.image = image;
        return frame;
    }
    
    CGImageRef imageRef = NULL;
    
    if (!imageRef) return nil;
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:_scale orientation:_orientation];
    CFRelease(imageRef);
    if (!image) return nil;
    
    image.eoc_isDecodedForDisplay = YES;
    frame.image = image;
    if (extendToCanvas) {
        frame.width = _width;
        frame.height = _height;
        frame.offsetX = 0;
        frame.offsetY = 0;
        frame.dispose = EOCImageDisposeNone;
        frame.blend = EOCImageBlendNone;
    }
    return frame;
}

- (CGImageRef)_newUnblendedImageAtIndex:(NSUInteger)index
                         extendToCanvas:(BOOL)extendToCanvas
                                decoded:(BOOL *)decoded CF_RETURNS_RETAINED {
    
    if (!_finalized && index > 0) return NULL;
    if (_frames.count <= index) return NULL;
    
    if (_source) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_source, index, (CFDictionaryRef)@{(id)kCGImageSourceShouldCache:@(YES)});
        if (imageRef && extendToCanvas) {
            size_t width = CGImageGetWidth(imageRef);
            size_t height = CGImageGetHeight(imageRef);
            if (width == _width && height == _height) {
                CGImageRef imageRefExtended = EOCCGImageCreateDecodedCopy(imageRef, YES);
                if (imageRefExtended) {
                    CFRelease(imageRef);
                    imageRef = imageRefExtended;
                    if (decoded) *decoded = YES;
                }
            } else {
                CGContextRef context = CGBitmapContextCreate(NULL, _width, _height, 8, 0, EOCCGColorSpaceGetDeviceRGB(), kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst);
                if (context) {
                    CGContextDrawImage(context, CGRectMake(0, _height - height, width, height), imageRef);
                    CGImageRef imageRefExtended = CGBitmapContextCreateImage(context);
                    CFRelease(context);
                    if (imageRefExtended) {
                        CFRelease(imageRef);
                        imageRef = imageRefExtended;
                        if (decoded) *decoded = YES;
                    }
                }
            }
        }
        return imageRef;
    }
    
    return NULL;
}

- (instancetype)initWithScale:(CGFloat)scale {
    self = [super init];
    if (scale <= 0) scale = 1;
    _scale = scale;
    _framesLock = dispatch_semaphore_create(1);
    
    pthread_mutexattr_t attr;
    pthread_mutexattr_init (&attr);
    pthread_mutexattr_settype (&attr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init (&_lock, &attr);
    pthread_mutexattr_destroy (&attr);
    
    return self;
}

- (BOOL)updateData:(NSData *)data final:(BOOL)final {
    BOOL result = NO;
    pthread_mutex_lock(&_lock);
    result = [self _updateData:data final:final];
    pthread_mutex_unlock(&_lock);
    return result;
}

#pragma private (wrap)
- (BOOL)_updateData:(NSData *)data final:(BOOL)final {
    
    if (_finalized) return NO;
    if (data.length < _data.length) return NO;
    _finalized = final;
    _data = data;
    
    EOCImageType type = EOCImageDetectType((__bridge CFDataRef)data);
    if (_sourceTypeDetected) {
        if (_type != type) {
            return NO;
        } else {
            [self _updateSource];
        }
    } else {
        if (_data.length > 16) {
            _type = type;
            _sourceTypeDetected = YES;
            [self _updateSource];
        }
    }
    return YES;
}

#pragma private

- (void)_updateSource {
    switch (_type) {
        case EOCImageTypeWebP: {
//            [self _updateSourceWebP];
        } break;
            
        case EOCImageTypePNG: {
//            [self _updateSourceAPNG];
        } break;
            
        default: {
            [self _updateSourceImageIO];
        } break;
    }
}

- (void)_updateSourceImageIO {
    
    _width = 0;
    _height = 0;
    _orientation = UIImageOrientationUp;
    _loopCount = 0;
    dispatch_semaphore_wait(_framesLock, DISPATCH_TIME_FOREVER);
    _frames = nil;
    dispatch_semaphore_signal(_framesLock);
    
    if (!_source) {
        if (_finalized) {
            _source = CGImageSourceCreateWithData((__bridge CFDataRef)_data, NULL);
        } else {
            _source = CGImageSourceCreateIncremental(NULL);
            if (_source) CGImageSourceUpdateData(_source, (__bridge CFDataRef)_data, false);
        }
    } else {
        CGImageSourceUpdateData(_source, (__bridge CFDataRef)_data, _finalized);
    }
    if (!_source) return;
    
    _frameCount = CGImageSourceGetCount(_source);
    if (_frameCount == 0) return;
    
    if (!_finalized) { // ignore multi-frame before finalized
        _frameCount = 1;
    } else {
        if (_type == EOCImageTypePNG) { // use custom apng decoder and ignore multi-frame
            _frameCount = 1;
        }
        if (_type == EOCImageTypeGIF) { // get gif loop count
            CFDictionaryRef properties = CGImageSourceCopyProperties(_source, NULL);
            if (properties) {
                CFDictionaryRef gif = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
                if (gif) {
                    CFTypeRef loop = CFDictionaryGetValue(gif, kCGImagePropertyGIFLoopCount);
                    if (loop) CFNumberGetValue(loop, kCFNumberNSIntegerType, &_loopCount);
                }
                CFRelease(properties);
            }
        }
    }
    
    /*
     ICO, GIF, APNG may contains multi-frame.
     */
    NSMutableArray *frames = [NSMutableArray new];
    for (NSUInteger i = 0; i < _frameCount; i++) {
        _EOCImageDecoderFrame *frame = [_EOCImageDecoderFrame new];
        frame.index = i;
        frame.blendFromIndex = i;
        frame.hasAlpha = YES;
        frame.isFullSize = YES;
        [frames addObject:frame];
        
        CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(_source, i, NULL);
        if (properties) {
            NSTimeInterval duration = 0;
            NSInteger orientationValue = 0, width = 0, height = 0;
            CFTypeRef value = NULL;
            
            value = CFDictionaryGetValue(properties, kCGImagePropertyPixelWidth);
            if (value) CFNumberGetValue(value, kCFNumberNSIntegerType, &width);
            value = CFDictionaryGetValue(properties, kCGImagePropertyPixelHeight);
            if (value) CFNumberGetValue(value, kCFNumberNSIntegerType, &height);
            if (_type == EOCImageTypeGIF) {
                CFDictionaryRef gif = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
                if (gif) {
                    // Use the unclamped frame delay if it exists.
                    value = CFDictionaryGetValue(gif, kCGImagePropertyGIFUnclampedDelayTime);
                    if (!value) {
                        // Fall back to the clamped frame delay if the unclamped frame delay does not exist.
                        value = CFDictionaryGetValue(gif, kCGImagePropertyGIFDelayTime);
                    }
                    if (value) CFNumberGetValue(value, kCFNumberDoubleType, &duration);
                }
            }
            
            frame.width = width;
            frame.height = height;
            frame.duration = duration;
            
            if (i == 0 && _width + _height == 0) { // init first frame
                _width = width;
                _height = height;
                value = CFDictionaryGetValue(properties, kCGImagePropertyOrientation);
                if (value) {
                    CFNumberGetValue(value, kCFNumberNSIntegerType, &orientationValue);
                    _orientation = EOCUIImageOrientationFromEXIFValue(orientationValue);
                }
            }
            CFRelease(properties);
        }
    }
    dispatch_semaphore_wait(_framesLock, DISPATCH_TIME_FOREVER);
    _frames = frames;
    dispatch_semaphore_signal(_framesLock);
}

@end


@implementation EOCImageEncoder

@end

@implementation UIImage (EOCImageCoder)

- (instancetype)eoc_imageByDecoded {
    if (self.eoc_isDecodedForDisplay) return self;
    CGImageRef imageRef = self.CGImage;
    if (!imageRef) return self;
    CGImageRef newImageRef = EOCCGImageCreateDecodedCopy(imageRef, YES);
    if (!newImageRef) return self;
    UIImage *newImage = [[self.class alloc] initWithCGImage:newImageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(newImageRef);
    if (!newImage) newImage = self; // decode failed, return self.
    newImage.eoc_isDecodedForDisplay = YES;
    return newImage;
}

- (BOOL)eoc_isDecodedForDisplay {
//    if (self.images.count > 1 || [self isKindOfClass:[YYSpriteSheetImage class]]) return YES;
    //这里最终是跟上面的那句一样
    if (self.images.count > 1) return YES;
    NSNumber *num = objc_getAssociatedObject(self, @selector(eoc_isDecodedForDisplay));
    return [num boolValue];
}

- (void)setEoc_isDecodedForDisplay:(BOOL)isDecodedForDisplay {
    objc_setAssociatedObject(self, @selector(eoc_isDecodedForDisplay), @(isDecodedForDisplay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
