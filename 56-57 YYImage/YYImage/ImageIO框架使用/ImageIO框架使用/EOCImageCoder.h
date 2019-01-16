//
//  EOCImageCoder.h
//  ImageIO框架使用
//
//  Created by 八点钟学院 on 2017/7/19.
//  Copyright © 2017年 八点钟学院. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, EOCImageType) {
    EOCImageTypeUnknown = 0, ///< unknown
    EOCImageTypeJPEG,        ///< jpeg, jpg
    EOCImageTypeJPEG2000,    ///< jp2
    EOCImageTypeTIFF,        ///< tiff, tif
    EOCImageTypeBMP,         ///< bmp
    EOCImageTypeICO,         ///< ico
    EOCImageTypeICNS,        ///< icns
    EOCImageTypeGIF,         ///< gif
    EOCImageTypePNG,         ///< png
    EOCImageTypeWebP,        ///< webp
    EOCImageTypeOther,       ///< other image format
};

typedef NS_ENUM(NSUInteger, EOCImageDisposeMethod) {
    
    EOCImageDisposeNone = 0,
    
    EOCImageDisposeBackground,
    
    EOCImageDisposePrevious,
};

typedef NS_ENUM(NSUInteger, EOCImageBlendOperation) {
    
    EOCImageBlendNone = 0,
    EOCImageBlendOver,
};

@interface EOCImageFrame : NSObject <NSCopying>
@property (nonatomic) NSUInteger index;    ///< Frame index (zero based)
@property (nonatomic) NSUInteger width;    ///< Frame width
@property (nonatomic) NSUInteger height;   ///< Frame height
@property (nonatomic) NSUInteger offsetX;  ///< Frame origin.x in canvas (left-bottom based)
@property (nonatomic) NSUInteger offsetY;  ///< Frame origin.y in canvas (left-bottom based)
@property (nonatomic) NSTimeInterval duration;          ///< Frame duration in seconds
@property (nonatomic) EOCImageDisposeMethod dispose;     ///< Frame dispose method.
@property (nonatomic) EOCImageBlendOperation blend;      ///< Frame blend operation.
@property (nullable, nonatomic, strong) UIImage *image; ///< The image.
+ (instancetype)frameWithImage:(UIImage *)image;
@end

@interface EOCImageDecoder : NSObject

@property (nullable, nonatomic, readonly) NSData *data;    ///< Image data.
@property (nonatomic, readonly) EOCImageType type;          ///< Image data type.
@property (nonatomic, readonly) CGFloat scale;             ///< Image scale.
@property (nonatomic, readonly) NSUInteger frameCount;     ///< Image frame count.
@property (nonatomic, readonly) NSUInteger loopCount;      ///< Image loop count, 0 means infinite.
@property (nonatomic, readonly) NSUInteger width;          ///< Image canvas width.
@property (nonatomic, readonly) NSUInteger height;         ///< Image canvas height.
@property (nonatomic, readonly, getter=isFinalized) BOOL finalized;

+ (instancetype)decoderWithData:(NSData *)data scale:(CGFloat)scale;
- (EOCImageFrame *)frameAtIndex:(NSUInteger)index decodeForDisplay:(BOOL)decodeForDisplay;

@end


@interface UIImage (EOCImageCoder)

- (instancetype)eoc_imageByDecoded;
@property (nonatomic) BOOL eoc_isDecodedForDisplay;

//- (nullable NSData *)eoc_imageDataRepresentation;

@end


@interface EOCImageEncoder : NSObject

@end

NS_ASSUME_NONNULL_END
