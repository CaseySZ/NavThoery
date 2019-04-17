//
//  AudioStreamPacketBufferPool.swift
//  AudioPlay
//
//  Created by Casey on 16/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit
import AVFoundation

class AudioStreamPacketBufferPool: NSObject {
    
    var _packetBufferArr = Array<AudioStreamPacketModel>()
    var _bufferSize = 0
    
    func enqueuePool(_ packets:Array<AudioStreamPacketModel>)  {
        
        for model in packets {
            
            _packetBufferArr.append(model)
            _bufferSize += model.data.count
        }
        
    }
    
    
    
    func dequeuePool(_ dataSize:UInt32, packetCount:UnsafeMutablePointer<UInt32>, packetDescription:UnsafeMutablePointer<UnsafeMutablePointer<AudioStreamPacketDescription>>) -> Data {
        
        if dataSize <= 0 || _packetBufferArr.count == 0 {
            return Data()
        }
        
        var audioStreamData = Data()
        
        var packetSize = Int(dataSize)
        var targetIndex = 0
        for model in _packetBufferArr {
            
            targetIndex = targetIndex + 1
            packetSize -= model.data.count
            if packetSize < 0 {
                break
            }
            
        }
        
        if targetIndex > _packetBufferArr.count-1 {
            targetIndex = _packetBufferArr.count - 1
        }
        
        
        for index in 0...targetIndex {
            
            let model = _packetBufferArr[index]
            
            var packetDesc = model.packetDesc
            packetDesc.mStartOffset = Int64(audioStreamData.count)
            
            var point = packetDescription.advanced(by: index)

            let newPacketDesc = UnsafeMutablePointer<AudioStreamPacketDescription>.allocate(capacity: 1)
            newPacketDesc.pointee = packetDesc
            
            point.pointee = newPacketDesc
           
            audioStreamData.append(model.data)
        }
        
       
        _packetBufferArr.removeSubrange(Range.init(NSRange.init(location: 0, length: targetIndex))!)
        _bufferSize -= audioStreamData.count
        
        
        return audioStreamData
    }
    
    
}
