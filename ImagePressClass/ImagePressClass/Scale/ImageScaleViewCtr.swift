//
//  ImageScaleViewCtr.swift
//  ImagePressClass
//
//  Created by Casey on 14/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

import UIKit

class ImageScaleViewCtr: UIViewController, UIScrollViewDelegate {

    @IBOutlet var _scrollerView:UIScrollView?
    @IBOutlet var _imageView:UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //_scrollerView?.maximumZoomScale = 5
     //   _scrollerView?.minimumZoomScale = 0.5
      
        
        bulidScale();
    }


    
    func bulidScale() {
        
        
        let pinchGesture = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchHandle(gesture:)))
        
        _scrollerView?.addGestureRecognizer(pinchGesture)
        
    }
    
    
    var _preScale:CGFloat?
    @objc func pinchHandle(gesture: UIPinchGestureRecognizer) {
        
        if gesture.state == .began {
            
            _preScale = 1
        }
        let scaleCurrent = gesture.scale - _preScale! + 1
        _preScale = gesture.scale
        
        _imageView?.transform = _imageView!.transform.scaledBy(x: scaleCurrent, y: scaleCurrent)
        
        _scrollerView?.contentSize = _imageView!.frame.size
        
    }
    
    
    
    //MARK: scrollView delegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return _imageView
    }

}
