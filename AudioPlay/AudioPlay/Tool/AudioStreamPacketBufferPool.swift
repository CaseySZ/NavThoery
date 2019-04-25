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
            _bufferSize += model.data.length
        }
        
    }
    
    
    
    func dequeuePool(_ dataSize:Int) -> (NSData, UInt32, NSArray) { //  Array<AudioStreamPacketDescription>
        
        if dataSize <= 0 || _packetBufferArr.count == 0 {
            print("dequeuePool zero")
            return (NSData(), 0, NSArray())
        }
       
        let audioStreamData = NSMutableData()
        
        var packetSize = dataSize
        var targetIndex = 0
        for model in _packetBufferArr {
            
            targetIndex = targetIndex + 1
            packetSize -= model.data.length
            if packetSize < 0 {
                break
            }
            
        }
        
        if targetIndex > _packetBufferArr.count-1 {
            targetIndex = _packetBufferArr.count - 1
        }
        
        if targetIndex > _packetBufferArr.count {
            targetIndex = _packetBufferArr.count
        }
      
        
       // var packetDescArr = Array<AudioStreamPacketDescription>.init()
        let packetDescArr = NSMutableArray.init()
        for index in 0...targetIndex {
            
            let model = _packetBufferArr[index]
            
            var packetDesc = model.packetDesc
            packetDesc.mStartOffset = Int64(audioStreamData.length)
            
            if let data = model.data as Data? {
                
                audioStreamData.append(data)
                packetDescArr.add(packetDesc)
                
            }else {
                
                print("数据问题1")
            }
            //audioStreamData.append(model.data.bytes, length: model.data.length) // 这个可能有异常
            
        }
        
       
        _packetBufferArr.removeSubrange(Range.init(NSRange.init(location: 0, length: targetIndex))!)
        _bufferSize -= audioStreamData.length
        
        print("dequeuePool")
        return (audioStreamData, UInt32(targetIndex), packetDescArr)
    }
    
    
}
