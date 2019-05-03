//
//  ScrollerMenuViewCtr.swift
//  EventThoery
//
//  Created by Casey on 02/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class ScrollerMenuViewCtr: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Menu"
        self.view.backgroundColor = .white
        
        let imageName = ["1", "2", "3"]
        
        let scrollview = CCScrollview.init(frame: CGRect.init(x: 50, y: 100, width: self.view.frame.size.width - 50*2, height: 200))
        scrollview.isPagingEnabled = true
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.contentSize = CGSize.init(width: scrollview.frame.size.width*CGFloat(imageName.count), height: scrollview.frame.size.height)
        scrollview.clipsToBounds = false
        self.view.addSubview(scrollview)
        
        
        for index in 0...imageName.count-1 {
            
            let imageView = UIImageView.init(image: UIImage.init(named: imageName[index]))
            imageView.frame = CGRect.init(x: CGFloat(index)*scrollview.frame.width, y: 0, width: scrollview.frame.width-20, height: scrollview.frame.height)
            scrollview.addSubview(imageView)
            
        }
        
        
    }
    

  

}
