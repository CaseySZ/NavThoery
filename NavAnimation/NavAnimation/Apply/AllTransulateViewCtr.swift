//
//  AllTransulateViewCtr.swift
//  NavAnimation
//
//  Created by Casey on 14/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

import UIKit

class AllTransulateViewCtr: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "AllTransulate"
        self.view.backgroundColor = .white
        
        methodStyle()
        
    }
    
    
    
    func methodStyle()  {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        let imageView = UIImageView.init(image: UIImage.init(named: "111.png"))
        imageView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 230)
        self.view.addSubview(imageView)
        
    }
    
    
    func methodStyleTwo()  {
        
        self.navigationController?.navigationBar.isTranslucent = false
        
       
        let navImageView = UIImageView.init(image: UIImage.init(named: "111.png"))
        navImageView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 230)
        let navBackgroundView = self.navigationController?.navigationBar.subviews.first
        navBackgroundView?.addSubview(navImageView)
        navBackgroundView?.clipsToBounds = true
        
        
        let imageView = UIImageView.init(image: UIImage.init(named: "111.png"))
        imageView.frame = CGRect.init(x: 0, y: -self.view.frame.origin.y, width: self.view.frame.width, height: 230)
        self.view.addSubview(imageView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // methodStyleTwo()
       // removeBottomBlackLine()
        removeBottomBlackLineTwo()
    }
    
    
    func removeBottomBlackLine()  {
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    
    func removeBottomBlackLineTwo()  {
        
        if let lineView = searchLine(self.navigationController!.navigationBar){
            
                lineView.isHidden = true
        }
        
    }
    
    
    func searchLine(_ view: UIView) -> UIView? {
        
        if view.frame.height <= 1 && view.isKind(of: UIImageView.classForCoder()) {
            return view
        }
        let viewArr = view.subviews
        for subView in viewArr {
            
            if let targetView =  searchLine(subView){
                return targetView
            }
        }
        
        return nil
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    

    
}
