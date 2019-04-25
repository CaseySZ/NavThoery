//
//  AudioStreamPacketModel.swift
//  AudioPlay
//
//  Created by Casey on 15/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit
import AVFoundation

class AudioStreamPacketModel: NSObject {

    let data:NSData
    let packetDesc:AudioStreamPacketDescription
    
    init(_ data:NSData, _ packetDesc:AudioStreamPacketDescription) {
        self.data = data
        self.packetDesc = AudioStreamPacketDescription.init(mStartOffset: packetDesc.mStartOffset, mVariableFramesInPacket: packetDesc.mVariableFramesInPacket, mDataByteSize: packetDesc.mDataByteSize)
    }
    
}
