//
//  CCAudioSession.swift
//  AudioPlay
//
//  Created by Casey on 15/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit
import AVFoundation

class CCAudioSession: NSObject {

    
    override init() {
        super.init()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(avAudionSessionInterruptionNotifi(_:)), name: AVAudioSession.interruptionNotification, object: nil)
        
        
    }
    
    @objc func avAudionSessionInterruptionNotifi(_ notifi:Notification) {
        
        print("打断了")
    }
    
    
    func active(_ active:Bool) throws {
        
        try AVAudioSession.sharedInstance().setActive(active, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
    
    }
    
    func category(_ category:AVAudioSession.Category) throws {
        
        if #available(iOS 11.0, *) {
            try AVAudioSession.sharedInstance().setCategory(category, mode: AVAudioSession.Mode.default, policy: AVAudioSession.RouteSharingPolicy.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        } else {
           
        }
        
        
    }
    
}
