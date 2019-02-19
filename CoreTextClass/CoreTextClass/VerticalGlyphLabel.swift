//
//  VerticalGlyphLabel.swift
//  CoreTextClass
//
//  Created by Casey on 19/02/2019.
//  Copyright © 2019 n. All rights reserved.
//

import UIKit

class VerticalGlyphLabel: UILabel {

 
    override func draw(_ rect: CGRect) {
        
        
        var infoDict = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor:UIColor.black]
        
        let attributeStr = NSMutableAttributedString.init(string: "abcde", attributes: infoDict)
        
        let frameSetterRef = CTFramesetterCreateWithAttributedString(attributeStr as CFAttributedString)
        
        
        let pathRef = CGMutablePath.init()
        pathRef.addRect(CGRect.init(x: 0, y: 0, width: 375, height: 300))
        
        let frameRef = CTFramesetterCreateFrame(frameSetterRef, CFRange.init(location: 0, length: 0), pathRef, nil)
        
        
        let context = UIGraphicsGetCurrentContext()
        
        
        
        
        
        
        
    }
 

}
