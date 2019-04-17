//
//  CCAudioStreamParse.swift
//  AudioPlay
//
//  Created by Casey on 15/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit
import AVFoundation

@objc protocol CCAudioStreamParseDelegate {
    
    func audioStreamParseForPackets(_ packetArr:NSArray)
}



class CCAudioStreamParse: NSObject {

    
    weak var delegate:CCAudioStreamParseDelegate?
    
    var _fileType = kAudioFileMP3Type
    var _fileSize:UInt32 = 0;
    var _duration:CGFloat = 0;// 时间长度
    
    var _audioFileStreamID:AudioFileStreamID?
    
    
    override init() {
        super.init()
    }
    
    
    convenience init(_ fileType:AudioFileTypeID, fileSize:UInt32) {
        
        self.init()
        _fileType = fileType
        _fileSize = fileSize
        createAudioSessionStream()
    }
    
    var _self:CCAudioStreamParse?
    func createAudioSessionStream()  {
        
        _self = self
        AudioFileStreamOpen(&_self, { (client, audioFileStream, propertyID, ioFlag) in
            
            print("文件属性处理")
            
            //var dd:UnsafeMutableRawPointer
            let target =  client.assumingMemoryBound(to: CCAudioStreamParse.self).pointee
            
          
                
            target.audioPropertyListenProc(audioFileStream, propertyID, ioFlag)
    
            
            
           
            
            
            
        }, { (client, numberBytes, numberPackets, inputData, packetDescriptions) in
            
            print("音频数据处理")
            
            let target =  client.assumingMemoryBound(to: CCAudioStreamParse.self).pointee
            target.audioFileStreamPacketProc(numberBytes, numberPackets, inputData, packetDescriptions)
                
            
            
            
        }, _fileType, &_audioFileStreamID)
        
        
        
    }
    
    
    func parserAudioStream(_ audioData:NSData) -> Bool{
        
        var flag = AudioFileStreamParseFlags.discontinuity
        if _isContinue {
            flag = AudioFileStreamParseFlags.init(rawValue: 0)
        }
        let status = AudioFileStreamParseBytes(_audioFileStreamID!, UInt32(audioData.length), audioData.bytes, flag)
        
        if status != noErr {
            print("AudioFileStreamParseBytes error: \(status)")
            return false
        }
        return true
    }
    
    
    var _audioDataOffset:UInt32 = 0
    var _biteRate:UInt32 = 0
    var _audioDataByteCount:UInt32 = 0
    var audioStreamBasicDescription = AudioStreamBasicDescription()
    var isReadyProductPacket = false
    var _isContinue = true; //是否连续
    func audioPropertyListenProc(_ audioFileStream:AudioFileStreamID, _ propertyID: AudioFileStreamPropertyID, _ ioFlags: UnsafeMutablePointer<AudioFileStreamPropertyFlags>) {
        
        
        if propertyID == kAudioFileStreamProperty_DataOffset {
            
            var size = UInt32(MemoryLayout.size(ofValue: _audioDataOffset))
            AudioFileStreamGetProperty(audioFileStream, propertyID, &size, &_audioDataOffset)
            
        }
        
        if propertyID == kAudioFileStreamProperty_BitRate {
            
            var size = UInt32(MemoryLayout.size(ofValue: _biteRate))
            AudioFileStreamGetProperty(audioFileStream, propertyID, &size, &_biteRate)
            
        }
        
        if propertyID == kAudioFileStreamProperty_AudioDataByteCount {
            
            var size = UInt32(MemoryLayout.size(ofValue: _audioDataByteCount))
            AudioFileStreamGetProperty(audioFileStream, propertyID, &size, &_audioDataByteCount)
            
        }
        
        if propertyID == kAudioFileStreamProperty_DataFormat {
            
            var size = UInt32(MemoryLayout.size(ofValue: audioStreamBasicDescription))
            AudioFileStreamGetProperty(audioFileStream, propertyID, &size, &audioStreamBasicDescription)
            
        }
        
        if propertyID == kAudioFileStreamProperty_ReadyToProducePackets {
            
             // 文件属性解析完了
            isReadyProductPacket = true
            _isContinue = false
           
            if _biteRate > 0 && _fileSize > 0 {
                
                _duration = CGFloat((_fileSize - _audioDataOffset)*8)/CGFloat(_biteRate)
                
            }
            
        }
    }
    
    
    func audioFileStreamPacketProc(_ numberBytes:UInt32, _ numberPackerts:UInt32, _ inputData:UnsafeRawPointer, _ packetDescriptions:UnsafeMutablePointer<AudioStreamPacketDescription>) {
        
        if numberBytes == 0 || numberPackerts == 0 {
            return
        }
        
        if !_isContinue {
            _isContinue = true
        }
        
        var packetArr = Array<AudioStreamPacketModel>()
        let audioData = NSData.init(bytes: inputData, length: Int(numberBytes*numberPackerts))
        //let audioData = Data.init(bytes: inputData, count: Int(numberBytes*numberPackerts) )
        for index in 0...numberPackerts-1 {
            
            let packetPoint = packetDescriptions.advanced(by: Int(index))
            let packetDesc =  packetPoint.pointee
        
            let packetData = audioData.subdata(with: NSRange.init(location: Int(packetDesc.mStartOffset), length: Int(packetDesc.mDataByteSize)))
            
            let packetModel = AudioStreamPacketModel.init(packetData, packetDesc)
            packetArr.append(packetModel)
        }
        
        // 数据解析完了
        self.delegate?.audioStreamParseForPackets(packetArr as NSArray)
        
    }
    
}
