//
//  备注.h
//  ImageIO框架使用
//
//  Created by 八点钟学院 on 2017/7/23.
//  Copyright © 2017年 八点钟学院. All rights reserved.
//

#ifndef ___h
#define ___h

1、imageNamed背后是调用的CGImageSourceCreateWithFile和CGImageSourceCreateImageAtIndex来获取到CGImageRef的（同样的图片只调用了一次，后面不会调用）
2、图片渲染到屏幕的时候会调用CGImageProviderCopyImageBlockSetWithOptions方法；


#endif /* ___h */
