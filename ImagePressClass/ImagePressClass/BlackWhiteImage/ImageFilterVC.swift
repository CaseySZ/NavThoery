//
//  ImageFilterVC.swift
//  ImagePressClass
//
//  Created by Casey on 14/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

import UIKit
import CoreGraphics
import CoreFoundation

class ImageFilterVC: UIViewController {

    
    @IBOutlet var blackWhiteImageView:UIImageView?
    @IBOutlet var _imageView:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        _imageView?.image = UIImage.init(named: "test.png")
        
        
    }
    
    
    
    func filterImage(_ cgImage:CGImage) -> UIImage? {
        
        
        let provideRef = cgImage.dataProvider
        if let decodeImageData =  provideRef?.data  {
            
            let lenght = CFDataGetLength(decodeImageData)
            
            let mutableData = CFDataCreateMutableCopy(kCFAllocatorSystemDefault, 0, decodeImageData)
            let pixelBuf =  CFDataGetMutableBytePtr(mutableData)
            var index = 0
            while index < lenght {
                
                changePixelFromBuffer(pixelBuf, postion: index)
                index += 4
                
            }
            
            
            let context =  CGContext.init(data: UnsafeMutableRawPointer.init(pixelBuf), width: cgImage.width, height: cgImage.height, bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: cgImage.bytesPerRow, space: cgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB(), bitmapInfo: cgImage.bitmapInfo.rawValue)
        
            if let newCGImage = context?.makeImage() {
                
                blackWhiteImageView?.image = UIImage.init(cgImage: newCGImage)
            }
            
            
        }
        
        
        
        return nil
    }
    
    func changePixelFromBuffer(_ pixelBuf: UnsafeMutablePointer<UInt8>?, postion: Int)  {
        
        
        let pixelR:UInt = UInt(pixelBuf?[postion] ?? 0)
        let pixelG:UInt = UInt(pixelBuf?[postion+1] ?? 0)
        let pixelB:UInt = UInt(pixelBuf?[postion+2] ?? 0)
        let pixelA:UInt = UInt(pixelBuf?[postion+3] ?? 0)
        
        print("\(pixelR)", "\(pixelG)", "\(pixelB)", "\(pixelA)")
        
        let level = (pixelR + pixelG + pixelB)/3
        
        pixelBuf?[postion] = UInt8(level)
        pixelBuf?[postion+1] = UInt8(level)
        pixelBuf?[postion+2] = UInt8(level)
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if let cgImage = UIImage.init(named: "test.png")?.cgImage {
            
            filterImage(cgImage)
        
        }
    }

}
