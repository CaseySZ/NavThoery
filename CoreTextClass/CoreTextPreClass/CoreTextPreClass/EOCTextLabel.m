//
//  EOCTextLabel.m
//  CoreTextPreClass
//
//  Created by EOC on 2017/4/18.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EOCTextLabel.h"
#import <CoreText/CoreText.h>

@implementation EOCTextLabel{
    
    
}

- (void)drawRect:(CGRect)rect {
    
    // 1 准备数据 NSMutableAttributedString
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
    [infoDict setObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
    NSMutableAttributedString *atttibuteString = [[NSMutableAttributedString alloc] initWithString:@"abcdefg123" attributes:infoDict];
    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)atttibuteString);
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, CGRectMake(0, 0, 375, 300));
    CTFrameRef frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, 0), pathRef, NULL);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    CTFrameDraw(frameRef, UIGraphicsGetCurrentContext());
    

    
    NSArray *lineRefAry = (__bridge NSArray*)CTFrameGetLines(frameRef);
    NSInteger lineCounts = lineRefAry.count;
    CGPoint lineOrigins[lineCounts];// memset
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), lineOrigins);
    
    CTLineRef lineRef = (__bridge CTLineRef)lineRefAry[0];
    CFArrayRef runs = CTLineGetGlyphRuns(lineRef);
    
    CGRect lineRect =  CTLineGetBoundsWithOptions(lineRef, 0);
   
    // 开始上下文
    
    
    
    
    for (NSUInteger r = 0, rMax = CFArrayGetCount(runs); r < rMax; r++) {
        CTRunRef run = CFArrayGetValueAtIndex(runs, r);
        NSRange runRange = NSMakeRange(CTRunGetStringRange(run).location, CTRunGetStringRange(run).length);
        CFDictionaryRef runAttrs = CTRunGetAttributes(run);
        
        CTFontRef runFont = CFDictionaryGetValue(runAttrs, kCTFontAttributeName);
        NSUInteger glyphCount = CTRunGetGlyphCount(run);
        
        CGGlyph glyphs[glyphCount];
        CGPoint glyphPositions[glyphCount];
        CTRunGetGlyphs(run, CFRangeMake(0, 0), glyphs);
        CTRunGetPositions(run, CFRangeMake(0, 0), glyphPositions);
        
        CGPoint zeroPoint = CGPointZero;
        
        NSUInteger rangeMax = runRange.location + runRange.length;
        
        for (NSUInteger g = runRange.location; g < rangeMax ; g++) {
          //  CGContextSaveGState(context); {
                
               // CGContextSetTextMatrix(context, CGAffineTransformIdentity);
                CGFloat glyplhX = 375 - glyphPositions[g].y - lineRect.size.height;//-300 + glyphPositions[g].x;
                CGFloat glyplhY = 300 - (g+ 1)*lineRect.size.height;
            
//            CGFloat glyplhX =  glyphPositions[g].y + lineRect.size.height;//-300 + glyphPositions[g].x;
//            CGFloat glyplhY =  (g+ 1)*lineRect.size.height;
            
                NSLog(@"%d:::  %f,%f ====== %f,%f", g, glyphPositions[g].x, glyphPositions[g].y, glyplhX, glyplhY);
                CGContextSetTextPosition(context,glyplhX, glyplhY); // CG 绘制的坐标系统是正常的，原点在右上角， CT的原点在右下角， ⚠️注意两个不通的坐标系统绘制
                
                CGFontRef cgFont = CTFontCopyGraphicsFont(runFont, NULL);
                CGContextSetFont(context, cgFont);
                CGContextSetFontSize(context, CTFontGetSize(runFont));
                CGContextShowGlyphsAtPositions(context, glyphs + g, &zeroPoint, 1); // zeroPoint 当前绘制的偏移位置
                CGFontRelease(cgFont);
                
          //  }CGContextRestoreGState(context);
        
        }
    }
}

/*
 
 */
/*
 CGFloat glyplhX = 375 - glyphPositions[g].y - lineRect.size.height;//-300 + glyphPositions[g].x;
 CGFloat glyplhY = 300 - (g+ 1)*14;glyphPositions[g].x;//347 + glyphPositions[g].y;
 CGContextSetTextPosition(context,glyplhX, glyplhY);
 
 CGFontRef cgFont = CTFontCopyGraphicsFont(runFont, NULL);
 CGContextSetFont(context, cgFont);
 CGContextSetFontSize(context, CTFontGetSize(runFont));
 CGContextShowGlyphsAtPositions(context, glyphs + g, &zeroPoint, 1);
 CGFontRelease(cgFont);
 
 */


/*
 
 CGContextSetTextMatrix(context, CGAffineTransformIdentity);
 
 
 CGContextRotateCTM(context, M_PI_2);
 
 CGFloat glyplhX = 50.0;//(50 + 14*g);//-300 + glyphPositions[g].x;
 CGFloat glyplhY = -( 50.0 + lineRect.size.height*g );// -50;//347 + glyphPositions[g].y;
 CGContextSetTextPosition(context,glyplhX, glyplhY);
 NSLog(@"%ld:::%f, %f", g, glyplhX, glyplhY);
 
 CGFontRef cgFont = CTFontCopyGraphicsFont(runFont, NULL);
 CGContextSetFont(context, cgFont);
 CGContextSetFontSize(context, CTFontGetSize(runFont));
 CGContextShowGlyphsAtPositions(context, glyphs + g, &zeroPoint, 1);
 CGFontRelease(cgFont);
 
 */
@end
