//
//  AudioStreamPacketModel.swift
//  AudioPlay
//
//  Created by Casey on 15/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit
import AVFoundation

class AudioStreamPacketModel {

    var data:Data
    var packetDesc:AudioStreamPacketDescription
    
    init(_ data:Data, _ packetDesc:AudioStreamPacketDescription) {
        self.data = data
        self.packetDesc = packetDesc
    }
    
}
