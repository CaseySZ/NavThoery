//
//  ImageCompressVC.swift
//  ImagePressClass
//
//  Created by Casey on 14/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

import UIKit

class ImageCompressVC: UIViewController {

    @IBOutlet var _imageView: UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "image compress"
        
    }
    
    
    /*
     图片解码
    */
    
    func imageCompress()  {
        
        
        let pathFile = Bundle.main.path(forResource: "3", ofType: "jpg")
        
        let image = UIImage.init(contentsOfFile: pathFile!)
        
        if let cgImage = image?.cgImage {
            let context = CGContext.init(data: nil, width: 300, height: 300, bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: cgImage.bytesPerRow, space: cgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB(), bitmapInfo: cgImage.bitmapInfo.rawValue)
        
            context?.draw(cgImage, in: CGRect.init(x: 0, y: 0, width: 300, height: 300))
            if let cgNewImage = context?.makeImage() {
                
                let newImage =  UIImage.init(cgImage: cgNewImage)
                _imageView?.image = newImage
                
                let rootDocument = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first! as NSString
                print(rootDocument)
                do {
                    try newImage.pngData()?.write(to: URL.init(fileURLWithPath: rootDocument.appendingPathComponent("test.png")))
                    
                }catch {
                
                }
            }
            
            
            
        }
        
        
    }
    
    var _testImage:UIImage?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        imageCompress()
    
       // _imageView?.image = UIImage.init(named: "3.jpg")
        
    }
    
    

}
