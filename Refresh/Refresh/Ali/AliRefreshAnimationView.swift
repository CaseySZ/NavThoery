//
//  AliRefreshAnimationView.swift
//  Refresh
//
//  Created by Casey on 12/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class AliRefreshAnimationView: UIView {
    
    let _waterImageView = UIImageView() // 水珠
    let _shadowView = AliRefreshShadowView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 6))
    
    let _contentView = UIView()
    let _logImageView = UIImageView()
    
    var _moveRate:CGFloat = 0 // 相对偏移比率
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _waterImageView.image = UIImage.init(named: "refreshWater.png")
        _waterImageView.isHidden = true
        _waterImageView.frame = CGRect.init(x: 0, y: 0, width: 10, height: 10)
        self.addSubview(_waterImageView)
        
        
        _shadowView.clipsToBounds = false
        _shadowView.backgroundColor = .clear
        _shadowView.y = self.height - 10 - 6
        _shadowView.centerX = self.width/2
        self.addSubview(_shadowView)
        
        _contentView.clipsToBounds = true
        _contentView.frame = CGRect.init(x: 0, y: 0, width: self.width, height: self.height - 10)
        self.addSubview(_contentView)
        
        _logImageView.image = UIImage.init(named: "refreshLog.png")
        _logImageView.frame = CGRect.init(x: self.width/2 - 29/2, y: self.height, width: 29, height: 24)
        _contentView.addSubview(_logImageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        if _moveRate == 0 {
            let logStartY = _logImageView.y
            let logEndY = self.height/2
            _moveRate = (logStartY - logEndY)/self.height
        }
    }
    
    // 根据offsetY来设置，子视图的位置
    func animationScrollViewOffsetY(_ offsetY:CGFloat)  {
        
        removeShakeAnimation()
        
        var minOffsetY = 0-offsetY
        if minOffsetY >= self.height {
            minOffsetY = self.height
        }
        
        let posY = _moveRate * minOffsetY
        _logImageView.y = self.height - posY
        _shadowView.visibleValueY = posY
        _shadowView.isHidden = false
        
        
    }
    
    // 准备加载 动画
    func animationStartLoading()  {
        
        _shadowView.animationCirle(0.3)
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self._logImageView.y = self.height/2 - self._logImageView.height/2 - 6
            
        }) { (finish) in
            
            self.shakeAnimation()
        }
        
    }
    
    // 左右摆动动画
    func shakeAnimation()  {
        
        let baseAnimation = CABasicAnimation.init()
        baseAnimation.keyPath = "transform.rotation.z"
        baseAnimation.duration = 0.25
        baseAnimation.fromValue = Double.pi/16
        baseAnimation.toValue = -Double.pi/16
        baseAnimation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeIn)
        baseAnimation.autoreverses = true
        baseAnimation.repeatCount = 1000
        baseAnimation.fillMode = .forwards
        _logImageView.layer.add(baseAnimation, forKey: "shakeAnimation")
    }
    
    // 移除动画
    func removeShakeAnimation()  {
        
        
        _logImageView.layer.removeAnimation(forKey: "shakeAnimation")
    }
    
    
    // 加载完 结束动画
    let endAnimationTime:CGFloat = 1 // 0.25
    func animationEndLoading(_ completion: (() -> Void)? )  {
        
        removeShakeAnimation()
        
        _shadowView.animationOvalEnd(endAnimationTime)
        
        _waterImageView.centerX = self.width/2
        _waterImageView.y = 10
        _waterImageView.width = 10
        _waterImageView.height = 10
        _waterImageView.isHidden = false
        
        UIView.animate(withDuration: Double(endAnimationTime), animations: {
            
            self._logImageView.y = self.height
            self._waterImageView.frame = CGRect.init(x: self.width/2 - 20/2, y: 5, width: 20, height: 20)
            
        }) { (finish) in
            
            completion?()
            self._waterImageView.isHidden = true
        }
        
    }
}
