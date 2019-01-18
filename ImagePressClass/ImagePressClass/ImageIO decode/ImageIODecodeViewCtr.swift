//
//  ImageIODecodeViewCtr.swift
//  ImagePressClass
//
//  Created by Casey on 17/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

import UIKit
import ImageIO

/*
 1 解码 比较 imageName 和 ImageIO操作后，内存遗留问题； kCGImageSourceShouldCacheImmediately 解码时机
 2 略缩图   查看 略缩图的size，比较和原图的内存大小
 3 渐进显示 分为两种不同的格式
 */

class ImageIODecodeViewCtr: UIViewController {

    @IBOutlet var _imageView:UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()

      
        
        let decodeItem = UIBarButtonItem.init(title: "decode", style: .plain, target: self, action: #selector(decode))
        let thumbNailItem = UIBarButtonItem.init(title: "thumbNail", style: .plain, target: self, action: #selector(thumbNail))
        let progressLoadItem = UIBarButtonItem.init(title: "progressLoad", style: .plain, target: self, action: #selector(startLoadImageEvent))
        
        self.navigationItem.rightBarButtonItems = [decodeItem, thumbNailItem, progressLoadItem]
        
    }

    
    
    
    @objc func decode()  {
        
        let filePath = Bundle.main.path(forResource: "bigImage", ofType: "jpg")
        do {
            
            if let fileData:CFData  = try Data.init(contentsOf: URL.init(fileURLWithPath: filePath!)) as CFData?{
                
                if let source = CGImageSourceCreateWithData(fileData, nil) {
                    
                    if let imageRef = CGImageSourceCreateImageAtIndex(source, 0, nil) {
                        
                        let image = UIImage.init(cgImage: imageRef)
                        _imageView?.image = image
                        
                    }
                }
                
            }
            
        } catch {
            
        }
       
        
    }
 
    
    
    @objc func thumbNail() {
        
        let filePath = Bundle.main.path(forResource: "bigImage", ofType: "jpg")
        do {
            
            if let fileData:CFData  = try Data.init(contentsOf: URL.init(fileURLWithPath: filePath!)) as CFData?{
                
                if let source = CGImageSourceCreateWithData(fileData, nil) {
                    
                    if let imageRef = CGImageSourceCreateThumbnailAtIndex(source, 0, nil) {
                        
                        let image = UIImage.init(cgImage: imageRef)
                        _imageView?.image = image
                        
                    }
                }
                
            }
            
        } catch {
            
        }
    }
    
    
    @objc func readProgressData(_ startOffSet:Int) -> Data? {
        
        
        let filePath = Bundle.main.path(forResource: "bigImage", ofType: "jpg")
        
        do {
            
                let fileData = try Data.init(contentsOf: URL.init(fileURLWithPath: filePath!))
                
                let loadSize = 1024*4
            
            if startOffSet + loadSize > fileData.count {
                
                if fileData.count-startOffSet <= 0 {
                    return nil
                }
                let data = fileData.subdata(in: (Range.init(NSRange.init(location: startOffSet, length: fileData.count-startOffSet)))! )
                return data
                
            }else {
                
                let data = fileData.subdata(in: (Range.init(NSRange.init(location: startOffSet, length: loadSize)))! )
                return data
                
            }
            
        } catch {
            
        }
        
        return nil
        
    }
    
    var _sourceIncremental:CGImageSource?
    var _imageData:Data?
    var _timer:Timer?
    @objc func loadProgresImage()  {
        
        if _sourceIncremental == nil {
            _sourceIncremental = CGImageSourceCreateIncremental(nil)
            _imageData = Data()
        }
        
        if let netData = readProgressData(_imageData!.count){
        
            _imageData?.append(netData)
            let cfData = _imageData as CFData?
            if netData.count == 1024*4{
                CGImageSourceUpdateData(_sourceIncremental!, cfData!, false)
            }else {
                CGImageSourceUpdateData(_sourceIncremental!, cfData!, true)
                _timer?.invalidate()
            }
            
            if let imageRef = CGImageSourceCreateImageAtIndex(_sourceIncremental!, 0, nil) {
                
                _imageView?.image = UIImage.init(cgImage: imageRef)
                
            }
            
        }else {
            
            _timer?.invalidate()
        }
    }
    
    
    @objc func startLoadImageEvent()  {
        
        if _timer == nil {
            
            _timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(loadProgresImage), userInfo: nil, repeats: true)
        
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    
    
}
