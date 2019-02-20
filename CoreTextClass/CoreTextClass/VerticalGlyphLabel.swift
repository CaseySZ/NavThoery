//
//  VerticalGlyphLabel.swift
//  CoreTextClass
//
//  Created by Casey on 19/02/2019.
//  Copyright © 2019 n. All rights reserved.
//

import UIKit
import CoreGraphics

class VerticalGlyphLabel: UILabel {

 
    override func draw(_ rect: CGRect) {
        
        
        let infoDict = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor:UIColor.black]
        
        let attributeStr = NSMutableAttributedString.init(string: "abcde", attributes: infoDict)
        
        let frameSetterRef = CTFramesetterCreateWithAttributedString(attributeStr as CFAttributedString)
        
        
        let pathRef = CGMutablePath.init()
        pathRef.addRect(CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        
        let frameRef = CTFramesetterCreateFrame(frameSetterRef, CFRange.init(location: 0, length: 0), pathRef, nil)
        
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.translateBy(x: 0, y: self.bounds.size.height)
        context?.scaleBy(x: 1, y: -1)
        
        CTFrameDraw(frameRef, context!)
        
        // ///
        
        let lineRefArr = CTFrameGetLines(frameRef) as! Array<CTLine>
        let lineCounts = lineRefArr.count
        var linePointArr:Array<CGPoint> = Array<CGPoint>()
        CTFrameGetLineOrigins(frameRef, CFRange.init(location: 0, length: 0), &linePointArr)
        
        let linePointer = UnsafeMutablePointer<CGPoint>.allocate(capacity: lineCounts)
        
        CTFrameGetLineOrigins(frameRef, CFRange.init(location: 0, length: 0), linePointer)
        
        
        let lineRef = lineRefArr[0]
        let runRefArr = CTLineGetGlyphRuns(lineRef) as! Array<CTRun>
        
        let lineRect = CTLineGetBoundsWithOptions(lineRef, CTLineBoundsOptions.excludeTypographicLeading)
        
        
        
        
        for index in 0...runRefArr.count-1 {
            
            
            let runRef = runRefArr[index]
            let runRange = CTRunGetStringRange(runRef) // 范围
            let rangeMax = runRange.location + runRange.length-1
            
            let glyphsCount =  CTRunGetGlyphCount(runRef) // 获取字符数
            let glyphs = UnsafeMutablePointer<CGGlyph>.allocate(capacity: glyphsCount)
            let glyphsPositions = UnsafeMutablePointer<CGPoint>.allocate(capacity: glyphsCount)
            CTRunGetGlyphs(runRef, CFRangeMake(0, 0), glyphs) // 获取字符数组
            CTRunGetPositions(runRef, CFRangeMake(0, 0), glyphsPositions) // 获取字符的位置
            
            
            for glyphIndex in runRange.location...rangeMax {
                
                
                let point = glyphsPositions.advanced(by: glyphIndex).pointee
                let glyph = glyphs.advanced(by: glyphIndex).pointee
                let glyplhX = self.frame.size.width - point.y - lineRect.height
                let glyplhY = self.frame.size.height - CGFloat(glyphIndex + 1) * lineRect.height
                
                print("=\(point),\(glyplhX),\(glyplhY),")
                context?.textPosition = CGPoint.init(x: glyplhX, y: glyplhY)
                context?.showGlyphs([glyph], at: [CGPoint.zero])
                
            }
            glyphs.deallocate()
            glyphsPositions.deallocate()
            
            
            
        }
        
        
        
    }
 

}
