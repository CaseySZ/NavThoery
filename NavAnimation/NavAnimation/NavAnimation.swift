//
//  NavAnimation.swift
//  NavAnimation
//
//  Created by Casey on 11/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

import UIKit

class NavAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 3.0
    }
    
    var _transitionContext:UIViewControllerContextTransitioning?
    var _toViewCtr:UIViewController?
    var _fromViewCtr:UIViewController?
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        _transitionContext = transitionContext
        
        let toViewCtr = transitionContext.viewController(forKey: .to)
        let fromViewCtr = transitionContext.viewController(forKey: .from)
        
        _toViewCtr  = toViewCtr
        _fromViewCtr = fromViewCtr
        
        //animationOne()
        animationTwo()
    }
    

    
    
    func animationOne()  {
        
        
        let transferView = _transitionContext!.containerView
        
        transferView.insertSubview(_toViewCtr!.view, belowSubview: _fromViewCtr!.view)
        
        UIView.animate(withDuration: transitionDuration(using: _transitionContext), animations: {
            
            let fromView = self._fromViewCtr!.view
            
            fromView!.frame = CGRect.init(x: fromView!.frame.width, y: fromView!.frame.minY, width: fromView!.frame.width, height: fromView!.frame.height)
            
        }) { (finish) in
            
            
            self._transitionContext?.completeTransition(true)
        }
        
    }
    
    
    
    func animationTwo()  {
        
        let transitionContext = _transitionContext!
        let toView   =   transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!
        
        toView.frame = transitionContext.finalFrame(for: _toViewCtr!)

        let dir:Double = -1.0
        
        let generalContentView = transitionContext.containerView
        
        generalContentView.addSubview(toView)
        
        
        
        var viewFromTransform = CATransform3DMakeRotation(CGFloat(dir*Double.pi)/2.0, 0.0, 1.0, 0.0)
        var viewToTransform = CATransform3DMakeRotation(CGFloat(-dir*Double.pi)/2.0, 0.0, 1.0, 0.0)
        
        toView.layer.anchorPoint = CGPoint.init(x: 1.0, y: 0.5)
        fromView.layer.anchorPoint = CGPoint.init(x: 0.0, y: 0.5)
        

        generalContentView.transform = CGAffineTransform.init(translationX: CGFloat(CGFloat(dir)*generalContentView.frame.width)/2, y: 0)
        
        viewFromTransform.m34 = 1.0 / 200.0
        viewToTransform.m34 = 1.0 / 200.0
        
        
        toView.layer.transform = viewToTransform
        
        
        
       
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            generalContentView.transform = CGAffineTransform.init(translationX: -CGFloat(dir*Double(generalContentView.frame.width))/2.0, y: 0)
            
            fromView.layer.transform = viewToTransform
            toView.layer.transform = CATransform3DIdentity
            
        }) { (finish) in
            
            
            generalContentView.layer.transform = CATransform3DIdentity
            
            fromView.layer.transform = CATransform3DIdentity
            toView.layer.transform = CATransform3DIdentity
            
            fromView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
            toView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
            
            
            if transitionContext.transitionWasCancelled {
                
                toView.removeFromSuperview()
            }else {
                fromView.removeFromSuperview()
            }
            
            transitionContext .completeTransition(!transitionContext.transitionWasCancelled)
        }

    }
    

    
}
