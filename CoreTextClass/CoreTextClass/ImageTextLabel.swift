//
//  ImageTextLabel.swift
//  CoreTextClass
//
//  Created by Casey on 30/01/2019.
//  Copyright © 2019 n. All rights reserved.
//


// https://www.jianshu.com/p/e90393ba2aea

import UIKit

class ImageTextLabel: UILabel {

    
    
    
    
    
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        //
        let attributeStr = NSMutableAttributedString.init(string: "Text")
        attributeStr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue], range: NSRange.init(location: 0, length: 4))
        
        
        // 占位符
        let specialAttri = specialAttibuteStringSize(CGSize.init(width: 100, height: 100))
        attributeStr.append(specialAttri)
        
        
        //
        let trailAttributeStr = NSMutableAttributedString.init(string: "After")
        trailAttributeStr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], range: NSRange.init(location: 0, length: 4))
        attributeStr.append(trailAttributeStr)
        
        //CFAttributedString
        let cfAttributeStr = attributeStr as CFAttributedString
        let frameSetterRef = CTFramesetterCreateWithAttributedString(cfAttributeStr)
       
        let path = CGPath.init(rect: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), transform: nil)
        let frameRef =  CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, 0), path, nil)
    
        
        if let context = UIGraphicsGetCurrentContext() {
            
            context.textMatrix = CGAffineTransform.identity
            context.translateBy(x: 0, y: self.frame.size.height);
            context.scaleBy(x: 1.0, y: -1.0)
            
            CTFrameDraw(frameRef, context)
            
            
        }
        
        searchInfoByFrame(frameRef)
        
        
    }
    
    
    var refCon = ["width": 100, "height":100]
    func specialAttibuteStringSize(_ size: CGSize) -> NSMutableAttributedString {
        
        
 
        var  callBacks = CTRunDelegateCallbacks.init(version: kCTRunDelegateVersion1, dealloc: { (rawPoint) in
            
            print("dealloc")
            
        }, getAscent: { (rawPoint) -> CGFloat in
        
            let valueUnsafePoint = rawPoint.bindMemory(to: Dictionary<String, Int>.self, capacity: 1)
            let ascent =  valueUnsafePoint.pointee["height"]
            print("S: \(ascent ?? 0)")
            return CGFloat.init(ascent ?? 0)/2
            
        }, getDescent: { (rawPoint) -> CGFloat in
            
            let valueUnsafePoint = rawPoint.bindMemory(to: Dictionary<String, Int>.self, capacity: 1)
            let ascent =  valueUnsafePoint.pointee["height"]
            print("D: \(ascent ?? 0)")
            return CGFloat.init(ascent ?? 0)/2
            
        }) { (rawPoint) -> CGFloat in
           
            
            let valueUnsafePoint = rawPoint.bindMemory(to: Dictionary<String, Int>.self, capacity: 1)
            let width =  valueUnsafePoint.pointee["width"]
            print("W: \(width ?? 0)")
           
            return CGFloat.init(width ?? 0)

        }
        
       // var refCon = ["width": 200, "height":200]
        
        let attributeStr = NSMutableAttributedString.init(string: " ")
        let keyStr = kCTRunDelegateAttributeName as String
        let runDelegate = CTRunDelegateCreate(&callBacks, &refCon);
        attributeStr.addAttribute(NSAttributedString.Key.init(keyStr), value: runDelegate!, range: NSRange.init(location: 0, length: 1))
        
        return attributeStr
        
        
        
        
        
        let callBackPoint = UnsafeMutablePointer<CTRunDelegateCallbacks>.allocate(capacity: 1)
        callBackPoint.advanced(by: 0).assign(repeating: callBacks, count: 0)
        
    
        let byteCount = MemoryLayout<Dictionary<String, CGFloat>>.stride
        let aligment = MemoryLayout<Dictionary<String, CGFloat>>.alignment
        let refConPoint = UnsafeMutableRawPointer.allocate(byteCount:byteCount , alignment: aligment)
       // refConPoint.storeBytes(of: refCon, as: Dictionary<String, CGFloat>.self)
        
    
        
        
//        if let delegate = CTRunDelegateCreate(UnsafePointer<CTRunDelegateCallbacks>.init(callBackPoint),refConPoint) {
//            CFAttributedStringSetAttribute(attributeStr as CFMutableAttributedString, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate)
//        }
        
        return attributeStr
        
        
    }
    
    
    
    
    var targetPosX:CGFloat = 0
    var targetPosY:CGFloat = 0
    func searchInfoByFrame(_ frameRef: CTFrame) {
        
        
        // 获取所有行的信息
        let lineRefArr = CTFrameGetLines(frameRef) as! Array<CTLine>
        let lineCount = lineRefArr.count
        
        let lintPoint = UnsafeMutablePointer<CGPoint>.allocate(capacity: lineCount)
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), lintPoint)
        
        
        for index in  0...lineCount-1 {
            
            let lineStartPoint =  lintPoint.advanced(by: index).pointee
            
            let lineRef = lineRefArr[index]
            
            let runRefArr =  CTLineGetGlyphRuns(lineRef) as! Array<CTRun>
            
            let targetIndex = 4
            var startPosX:CGFloat = 0
            var startY:CGFloat = 0
            for runIndex in 0...runRefArr.count - 1 {
                
                let runRef =  runRefArr[runIndex]
                
                let runRange = CTRunGetStringRange(runRef)
                
                
                var ascent:CGFloat = 0
                var descent:CGFloat = 0
                var lineGap:CGFloat = 0
                let runWidth = CTRunGetTypographicBounds(runRef, CFRange.init(location: 0, length: 0), &ascent, &descent, &lineGap)
                
                
                if runIndex == 0 {
                    startY = ascent + descent + lineGap + lineStartPoint.y
                }
                if targetIndex >= runRange.location && targetIndex < runRange.location + runRange.length {
                    
                    targetPosX = startPosX
                    targetPosY = self.frame.size.height - startY
                    
                    break
                }
                
                startPosX += CGFloat(runWidth)
                
            }
            
            
        }
        
        
        
        self.setNeedsLayout()
    }

    
    let orangeView = UIView.init()
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        orangeView.frame = CGRect.init(x: targetPosX, y: targetPosY, width: 100, height: 100)
        orangeView.backgroundColor = UIColor.orange
        if orangeView.superview == nil {
            self.addSubview(orangeView)
        }
        
        
    }
    
}
