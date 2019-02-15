//
//  ImageQRCodeViewCtr.swift
//  ImagePressClass
//
//  Created by Casey on 15/02/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

import UIKit
import CoreImage



class ImageQRCodeViewCtr: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        let imageView = UIImageView.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
        
        imageView.image = createQRCode("http://www.baidu.com")
        
        self.view.addSubview(imageView)
        
    }
    
    
    func createQRCode(_ content:String) -> UIImage? {
        
        
        
        let qrFilter = CIFilter.init(name: "CIQRCodeGenerator")
        qrFilter?.setDefaults()
        qrFilter?.setValue(content.data(using: .utf8, allowLossyConversion: true), forKey: "inputMessage")
        
        if  let ciImage = qrFilter?.outputImage {
        
            let ciContext =  CIContext.init()
            if let cgImage = ciContext.createCGImage(ciImage, from: CGRect.init(x: 0, y: 0, width: 100, height: 100)){
                
                
                let context =  CGContext.init(data:nil, width: cgImage.width, height: cgImage.height, bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: cgImage.bytesPerRow, space: cgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB(), bitmapInfo: cgImage.bitmapInfo.rawValue)
                
                
                if let newCGImage = context?.makeImage() {
                    
                    let newImage =  UIImage.init(cgImage: newCGImage)
                    
                    return newImage
                }
                
            }
        
            
            
            
        }
        
        
        
        return nil
    }
    
    

}
