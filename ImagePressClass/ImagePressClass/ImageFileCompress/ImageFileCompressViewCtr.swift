//
//  ImageCompressViewCtr.swift
//  ImagePressClass
//
//  Created by Casey on 14/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

import UIKit

class ImageFileCompressViewCtr: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet var pngImageView:UIImageView?
    @IBOutlet var jpgImageView:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "File Compress"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Album", style: .plain, target: self, action: #selector(openAlbum))
       
    }

    
    
    @objc func openAlbum()  {
        
        
        let imagePickerViewCtr = UIImagePickerController.init()
        imagePickerViewCtr.delegate = self
        imagePickerViewCtr.sourceType = .photoLibrary
        self .present(imagePickerViewCtr, animated: true, completion: nil)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if _selectImage != nil {
            imageDataLoad(albumImage: _selectImage!)
        }
    }
    
    
    
    func imageDataLoad(albumImage: UIImage)  {
        
        pngImageView?.image = albumImage
        jpgImageView?.image = albumImage
        
        let pngData = albumImage.pngData()
        
        
        var jpgData = albumImage.jpegData(compressionQuality: 1)

        sizeCalculate(size: pngData!.count)
        sizeCalculate(size: jpgData!.count)
        
        
        // 压缩文件上传，如果需求有设置文件大小范围，我们需要压缩到指定大小范围内
        compressToSize(albumImage)
    }
    
    // 压缩到指定大小
    func compressToSize(_ albumImage:UIImage)  {
        
        var scale:CGFloat = 0.9
        var jpgData = albumImage.jpegData(compressionQuality: scale)
        while jpgData!.count > 1024*1024 {
            
            scale = scale - 0.1
            jpgData = albumImage.jpegData(compressionQuality: scale)
            if scale <= 0.1{
                break
            }
        }
        
        sizeCalculate(size: jpgData!.count)
    }
    
    func sizeCalculate(size: Int) {
        
        let sizeKB = size/1024
        if sizeKB < 1024 {
            print("\(sizeKB)KB")
        }else {
            let sizeMB = sizeKB/1024
            print("\(sizeMB)MB")
        }
    }
    
    // MARK: 系统相册
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
  
    
    var _selectImage:UIImage?
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        _selectImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage?
        self.dismiss(animated: true, completion: nil)
    
    }
    

}
