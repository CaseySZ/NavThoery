//
//  ViewController.swift
//  ImageDeep Swift
//
//  Created by Casey on 14/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit
import CoreServices


class ViewController: UIViewController {

    
    @IBOutlet var imageView:UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageJPGItem = UIBarButtonItem.init(title: "JPG", style: .plain, target: self, action: #selector(uiimageJPG))
        let imageItem = UIBarButtonItem.init(title: "Png", style: .plain, target: self, action: #selector(uiimageloadPng))
        let contextItem = UIBarButtonItem.init(title: "Context", style: .plain, target: self, action: #selector(contextImage))
        let desItem = UIBarButtonItem.init(title: "Destination", style: .plain, target: self, action: #selector(imageDestination))
        self.navigationItem.rightBarButtonItems = [imageJPGItem, imageItem, contextItem, desItem]
        
        
    }

    
    @objc func uiimageJPG() {
        
        imageView?.image = UIImage.init(named: "bigImage.jpg");
        
        
    }
    
    @objc func uiimageloadPng() {
        
    
        let filePath = Bundle.main.path(forResource: "11", ofType: "png")
        do {
            
            if let fileData:CFData  = try Data.init(contentsOf: URL.init(fileURLWithPath: filePath!)) as CFData?{
                
                if let source = CGImageSourceCreateWithData(fileData, nil) {
                
                        
                        if let imageRef = CGImageSourceCreateImageAtIndex(source, 0, nil) {
                            
                            
                            let image = UIImage.init(cgImage: imageRef)
                            
                            
                            
                        }
                }
            }
            
        } catch {
            
        }
        
    }
    
    

    @objc func contextImage() {
        
        
        UIGraphicsBeginImageContext(CGSize.init(width: 200, height: 200))
        let context = UIGraphicsGetCurrentContext()
        
        let image = UIImage.init(named: "11.png")
        
        context?.draw(image!.cgImage!, in: CGRect.init(x: 0, y: 0, width: 200, height: 200))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        imageView?.image = newImage
        
    }

    @objc func imageDestination() {
        
        let image = UIImage.init(named: "11.png")
        
        let gifImageData = NSMutableData()
        let dataCFRef = gifImageData as CFMutableData
        
        let destinationSource = CGImageDestinationCreateWithData(dataCFRef, kUTTypePNG, 1, nil)
        CGImageDestinationAddImage(destinationSource!, image!.cgImage!, nil)
        CGImageDestinationFinalize(destinationSource!)
        
        
        
    }
    

}

