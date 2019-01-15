//
//  ShotScreenImageVC.swift
//  ImagePressClass
//
//  Created by Casey on 14/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

import UIKit
import CoreGraphics

class ShotScreenImageVC: UIViewController {

    @IBOutlet var _imageView:UIImageView?
    @IBOutlet var _cicleImageView:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ShotImage"
        
        
        let customItem =  UIBarButtonItem.init(title: "custom", style: .plain, target: self, action: #selector(shotAction))
        let circleItem =  UIBarButtonItem.init(title: "circle", style: .plain, target: self, action: #selector(circleShotAction))
        
        self.navigationItem.rightBarButtonItems = [customItem, circleItem]
        
        
        
    }

    
    @objc func shotAction() {
        
        
        if let image = UIImage.init(named: "3.jpg"){
            
            _imageView?.image =  colorMaskImage(image)
        }
    }
    
    
    @objc func circleShotAction() {
        
        if let image = UIImage.init(named: "3.jpg"){
            
           _cicleImageView?.image =  circleImage(image)
        }
        
    }
    
    
    func circleImage(_ image: UIImage) -> UIImage? {
        
        if let cgImage = image.cgImage {
            
          //  let context = CGContext.init(data: nil, width: 200, height: 200, bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: cgImage.bytesPerRow, space: cgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB(), bitmapInfo: cgImage.bitmapInfo.rawValue)
          
            UIGraphicsBeginImageContext(CGSize.init(width: 200, height: 200))
            let context = UIGraphicsGetCurrentContext()
            
            ///
            
            context?.setLineWidth(1)
            context?.setStrokeColor(UIColor.red.cgColor)
            
            context?.addEllipse(in: CGRect.init(x: 0, y: 0, width: 200, height: 200))
            context?.clip()
            
            image.draw(in: CGRect.init(x: 0, y: 0, width: 200, height: 200))
            
            
            let newImage =  UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            
            return newImage
            
        }
        
        
        return nil
    }
    

    func colorMaskImage(_ image: UIImage) -> UIImage? {
        
        
        UIGraphicsBeginImageContext(CGSize.init(width: 200, height: 200))
        let context = UIGraphicsGetCurrentContext()
        
        image.draw(in: CGRect.init(x: 0, y: 0, width: 200, height: 200))
        
        
        context?.setFillColor(UIColor.red.withAlphaComponent(0.5).cgColor)
        context?.setBlendMode(.normal)
        context?.fill(CGRect.init(x: 0, y: 0, width: 200, height: 200))
        
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
   

}
