//
//  ImageIOEncodeVC.swift
//  ImagePressClass
//
//  Created by Casey on 17/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

import UIKit
import CoreServices

/*
*/
class ImageIOEncodeVC: UIViewController {

    
    @IBOutlet var _imageView:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        self.title = "imageIO Encode"
        
        let decodeItem = UIBarButtonItem.init(title: "createGifImage", style: .plain, target: self, action: #selector(createGifImage))
        let thumbNailItem = UIBarButtonItem.init(title: "compress", style: .plain, target: self, action: #selector(compress))
        let progressLoadItem = UIBarButtonItem.init(title: "scanGifImage", style: .plain, target: self, action: #selector(scanGifImage))
        
        self.navigationItem.rightBarButtonItems = [progressLoadItem, decodeItem, thumbNailItem]
        
        
        
    }
    
    
    var imageIndex:Int = 0
    @objc func scanGifImage() {
        
        
        let filePath = Bundle.main.path(forResource: "gif", ofType: "gif")
        do {
            
            if let fileData:CFData  = try Data.init(contentsOf: URL.init(fileURLWithPath: filePath!)) as CFData?{
                
                if let source = CGImageSourceCreateWithData(fileData, nil) {
                    
                    let maxCount = CGImageSourceGetCount(source)
                    if imageIndex < maxCount {
                        
                        if let imageRef = CGImageSourceCreateImageAtIndex(source, imageIndex, nil) {
                            
                            let imageInfo =  CGImageSourceCopyPropertiesAtIndex(source, imageIndex, nil)
                            print(imageInfo ?? "")
                            let image = UIImage.init(cgImage: imageRef)
                            _imageView?.image = image
                            
                            imageIndex += 1
                            
                        }
                    }
                }
                
            }
            
        } catch {
            
        }
        
    }
    
    
    @objc func createGifImage() {
        
        var imageArr = Array<UIImage>()
        for index in 1...9 {
            
            let image = UIImage.init(named: String.init(format: "%d.png", index))
            
            imageArr.append(image!)
            
        }
        
        let gifImageData = NSMutableData()
        
        let dataCFRef = gifImageData as CFMutableData
        

        destinationSource = CGImageDestinationCreateWithData(dataCFRef, kUTTypeGIF, imageArr.count, nil)
       
        for image in imageArr {
            
            let imageGifInfo = [kCGImagePropertyGIFDictionary : [kCGImagePropertyGIFDelayTime:1] ] as CFDictionary
            CGImageDestinationAddImage(destinationSource!, image.cgImage!, imageGifInfo)
        }
        
        CGImageDestinationFinalize(destinationSource!)
        
        var documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        documentPath?.append("/")
        documentPath?.append("test22.gif")
        print(documentPath!)
        gifImageData.write(toFile: documentPath!, atomically: true)
        
        
    }
    
    
    var destinationSource:CGImageDestination?
    @objc func compress() {
        
        
        let imageData = NSMutableData() // 注意这里要用NSMutableData，不能用Data，分析为什么
        
        let dataCFRef = imageData as CFMutableData
        
        let bigImage = UIImage.init(named: "bigImage.jpg")
        
        
        let infoDict = [ kCGImageDestinationImageMaxPixelSize : 200 ] as CFDictionary
        
        destinationSource = CGImageDestinationCreateWithData(dataCFRef, kUTTypeJPEG , 1, infoDict)
        
        
        let imageInfo = [kCGImageDestinationLossyCompressionQuality : 0.2] as CFDictionary
        
        if let cgImage = bigImage?.cgImage {
            CGImageDestinationAddImage(destinationSource!, cgImage, imageInfo)
        }
        CGImageDestinationFinalize(destinationSource!)
        
        
        _imageView?.image = UIImage.init(data: imageData as Data)
        
    }



}
