//
//  CCTableView.swift
//  EventThoery
//
//  Created by Casey on 03/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class CCTableView: UITableView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("CCTableView touchesBegan")
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("CCTableView touchesMoved")
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("CCTableView touchesEnded")
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("CCTableView touchesCancelled")
        super.touchesCancelled(touches, with: event)
    }

}
