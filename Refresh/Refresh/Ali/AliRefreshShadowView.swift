//
//  AliRefreshShadowView.swift
//  Refresh
//
//  Created by Casey on 12/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class AliRefreshShadowView: UIView, CAAnimationDelegate {

    let rateWidth:CGFloat = 37/25.0
    let _shadowColor = UIColor.init(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
    
    var _animationIng = false
    var _circelAnimation = false
    
    
    let _shapeLayer = CAShapeLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _shapeLayer.frame = self.bounds
        _shapeLayer.fillColor = _shadowColor.cgColor
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if !_circelAnimation {
            
            drawOval()
        }
        
        
    }
    
    
    
    
    var _visibleValueY:CGFloat = 0
    var visibleValueY:CGFloat {
        
        get {
            return _visibleValueY
        }set {
            _visibleValueY = newValue
            self._circelAnimation = false
            self._shapeLayer.removeFromSuperlayer()
            self.setNeedsDisplay()
        }
        
    }
    
    // 设置阴影大小
    func drawOval()  {
        
        
        let shadowWidth = _visibleValueY*self.rateWidth
        let path = UIBezierPath.init(ovalIn: CGRect.init(x: self.width/2-shadowWidth/2, y: 0, width: shadowWidth, height: height))
        _shadowColor.set()
        path.fill()
        path.stroke()
        
        _shapeLayer.path = path.cgPath
        
    }
    
    // 开始时，阴影变小
    func animationCirle(_ animationTime:CGFloat) {
        
        _circelAnimation = true
        if _animationIng {
            return
        }

        if _shapeLayer.superlayer == nil {
            self.layer .addSublayer(_shapeLayer)
        }
        
        _animationIng = true
        
        let shadowWidth:CGFloat = 10
        _shapeLayer.path = UIBezierPath.init(ovalIn: CGRect.init(x: self.width/2 - shadowWidth/2, y: 0, width: shadowWidth, height: self.height)).cgPath
        
        let baseAnimation = CABasicAnimation.init()
        baseAnimation.keyPath = "path"
        baseAnimation.duration = Double(animationTime)
        baseAnimation.fromValue = _shapeLayer.path
        baseAnimation.toValue = UIBezierPath.init(ovalIn: CGRect.init(x: self.width/2 - shadowWidth/2, y: 0, width: shadowWidth, height: self.height)).cgPath
        baseAnimation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)
        baseAnimation.autoreverses = false
        baseAnimation.fillMode = .forwards
        baseAnimation.delegate = self
        _shapeLayer.add(baseAnimation, forKey: "baseAnimationPath")
        
    }
    
    // 结束时，阴影动画 （椭圆到，从小到大,）
    func animationOvalEnd(_ animationTime:CGFloat)  {
        
        
        _circelAnimation = true
        _shapeLayer.removeAnimation(forKey: "baseAnimationPath")
        
        if _shapeLayer.superlayer == nil {
            self.layer .addSublayer(_shapeLayer)
        }
        
        _animationIng = true
        
        let shadowWidth:CGFloat = 37
        _shapeLayer.path = UIBezierPath.init(ovalIn: CGRect.init(x: self.width/2 - shadowWidth/2, y: 0, width: shadowWidth, height: height)).cgPath
        
        let baseAnimation = CABasicAnimation.init()
        baseAnimation.keyPath = "path"
        baseAnimation.duration = Double(animationTime)
        baseAnimation.fromValue = _shapeLayer.path
        baseAnimation.toValue = UIBezierPath.init(ovalIn: CGRect.init(x: self.width/2 - shadowWidth/2, y: 0, width: shadowWidth, height: height)).cgPath
        baseAnimation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)
        baseAnimation.autoreverses = false
        baseAnimation.fillMode = .forwards
        baseAnimation.delegate = self
        baseAnimation .setValue("1", forKey: "animationOval")
        _shapeLayer.add(baseAnimation, forKey: "baseAnimationPathT")
        
    }
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        _shapeLayer.removeAnimation(forKey: "baseAnimationPath")
        if anim.value(forKey: "animationOval") != nil {
            _shapeLayer.removeFromSuperlayer()
        }
        _animationIng = false
    }
    
}
