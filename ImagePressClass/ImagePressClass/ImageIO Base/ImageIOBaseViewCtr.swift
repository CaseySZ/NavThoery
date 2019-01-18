//
//  ImageIOBaseViewCtr.swift
//  ImagePressClass
//
//  Created by Casey on 17/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

import UIKit
import ImageIO

/*
 解码
 
 编码
 */

class ImageIOBaseViewCtr: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "imageIO"
        
        let decodeItem = UIBarButtonItem.init(title: "AllType", style: .plain, target: self, action: #selector(supportImageType))
        let thumbNailItem = UIBarButtonItem.init(title: "ImageType", style: .plain, target: self, action: #selector(getImageType))
        let progressLoadItem = UIBarButtonItem.init(title: "ImageInfo", style: .plain, target: self, action: #selector(getImageInfo))
        
        self.navigationItem.rightBarButtonItems = [decodeItem, thumbNailItem, progressLoadItem]
        
    }
 
    
    
    @objc func supportImageType() {
        
        let typeArr = CGImageSourceCopyTypeIdentifiers()
        print(typeArr)
        
    }
    
    
    @objc func getImageType() {
        
        let filePath = Bundle.main.path(forResource: "bigImage", ofType: "jpg")
        do {
            
            if let fileData:CFData  = try Data.init(contentsOf: URL.init(fileURLWithPath: filePath!)) as CFData?{
                
                if let source = CGImageSourceCreateWithData(fileData, nil) {
                    
                    let type = CGImageSourceGetType(source)
                    
                    print(type!)
            
                }
                
            }
            
        } catch {
            
        }
        
    }
    
    
    @objc func getImageInfo() {
        
        
        let filePath = Bundle.main.path(forResource: "bigImage", ofType: "jpg")
        do {
            
            if let fileData:CFData  = try Data.init(contentsOf: URL.init(fileURLWithPath: filePath!)) as CFData?{
                
                if let source = CGImageSourceCreateWithData(fileData, nil) {
                    
                    let soureInfo = CGImageSourceCopyProperties(source, nil)
                    print(soureInfo!)
                    
                    print("==========")
                    let imageInfo = CGImageSourceCopyPropertiesAtIndex(source, 0, nil)
                    
                    print(imageInfo!)
                    
                }
                
            }
            
        } catch {
            
        }
    }
    

}
