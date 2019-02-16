//
//  ViewController.swift
//  ImagePressClass
//
//  Created by Casey on 14/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Image"
        
        
    }

    
    //MARK: tableview delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 64
    }
    let titleArr = ["图片文件压缩", "图片压缩", "Filter", "Shot", "Scale", "ImageIO", "ImageIODecode", "ImageIOEncode", "CIIMage", "", "", "", "", ""]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = titleArr[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if indexPath.row == 0{
            
            self.navigationController?.pushViewController(ImageFileCompressViewCtr(), animated: true)
        }
        
        if indexPath.row == 1 {
            
            self.navigationController?.pushViewController(ImageCompressVC(), animated: true)
            
        }
        if indexPath.row == 2 {
            
            self.navigationController?.pushViewController(ImageFilterVC(), animated: true)
            
        }
        if indexPath.row == 3 {
            
            self.navigationController?.pushViewController(ShotScreenImageVC(), animated: true)
            
        }
        if indexPath.row == 4{
            
            self.navigationController?.pushViewController(ImageScaleViewCtr(), animated: true)
            
        }
        if indexPath.row == 5{
            
            self.navigationController?.pushViewController(ImageIOBaseViewCtr(), animated: true)
            
        }
        
        if indexPath.row == 6{
            
            self.navigationController?.pushViewController(ImageIODecodeViewCtr(), animated: true)
            
        }
        if indexPath.row == 7{
            
            self.navigationController?.pushViewController(ImageIOEncodeVC(), animated: true)
            
        }
        if indexPath.row == 8{
            
            self.navigationController?.pushViewController(ImageQRCodeViewCtr(), animated: true)
            
        }
        
    }

    
    
    
    
}

