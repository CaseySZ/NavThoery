//
//  AudioPlayerViewCtr.swift
//  AudioPlay
//
//  Created by Casey on 15/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayerViewCtr: UIViewController, CCAudioStreamParseDelegate {

    let audioSeesion = CCAudioSession()
    var ccAudioStreamParse:CCAudioStreamParse?
    var ccBufferPool = AudioStreamPacketBufferPool()
    var ccAudioQueueRead = AudioQueueRead()
    
    var _fileHandle:FileHandle?
    var _fileSize = 0
    var _fileOffset = 0
    var _bufferSize = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let filePath = Bundle.main.path(forResource: "MP3Sample", ofType: "mp3")
        
        _fileHandle = FileHandle.init(forReadingAtPath: filePath!)
        
        do {
            
            _fileSize = try FileManager.default.attributesOfItem(atPath: filePath!)[FileAttributeKey.size] as? Int ?? 0
            
        }catch {
            
        }
        
        _bufferSize = _fileSize/500
        
        
        ccAudioStreamParse = CCAudioStreamParse.init(kAudioFileMP3Type, fileSize: UInt32(_fileSize))
        ccAudioStreamParse?.delegate = self
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !_playing {
            _playing = true
            
            Thread.detachNewThreadSelector(#selector(audioPlayThread), toTarget: self, with: nil)
        }
    }
    
    var _playing = false
    @objc func audioPlayThread()  {
        
        do {
        
            try audioSeesion.active(true)
            
            try audioSeesion.category(AVAudioSession.Category.playback)
            
            
        
        }catch {
            
            print("error: \(error)")
            
        }
        
        
        var isEOF = false

        while _fileSize > 0 {
            
            
            if !_playing {
                break
            }
            
            var data:NSData?
            if !isEOF {
                
                if let fileData = _fileHandle?.readData(ofLength: 500) {
                    _fileOffset += fileData.count
                    if _fileOffset >= _fileSize {
                        isEOF = true
                        print("finish EOF")
                    }
                    data = fileData as NSData?
                } else {
                    print("文件出错了")
                }
                
            }
            
            
            if let audioData = data{
                
                
                if  ccAudioStreamParse!.parserAudioStream(audioData) == false {
                    print("解析数据出问题了")
                    break
                }
                
                if ccAudioStreamParse!.isReadyProductPacket {
                    
                    if ccAudioQueueRead._audioQueue == nil {
                        
                        if !ccAudioQueueRead.createQueue(ccAudioStreamParse?.audioStreamBasicDescription, UInt32(_bufferSize)) {
                            print("createQueue出问题了")
                            break
                        }
                        
                    }
                    
                    
                    
                    if ccBufferPool._bufferSize < _bufferSize {
                        continue
                    }
                    
            
                    let (streamData, packetCount, packetDescArr) = ccBufferPool.dequeuePool(_bufferSize)
                    
                   
                    
                    if !ccAudioQueueRead.playerAudioQueue(streamData, packetCount, packetDescs: packetDescArr) {
                        
                        print("playerAudioQueue fail")
                    }
                        
                    
                    
                    
                }
                
                
            }
            
        }
        print("while finish")
        RunLoop.current.add(Port(), forMode: .default)
        RunLoop.current.run();
        print("thread finish")
    }
    
    
    func audioStreamParseForPackets(_ packetArr:NSArray) {
        
        if let packets =  packetArr as? Array<AudioStreamPacketModel> {
        
            ccBufferPool.enqueuePool(packets)
        }
        
        
    }

}
