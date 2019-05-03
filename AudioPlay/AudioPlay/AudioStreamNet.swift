//
//  AudioStreamNet.swift
//  AudioPlay
//
//  Created by Casey on 03/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit


@objc protocol AudioStreamNetDelegate {
    
    func netHandDataWithResponse(_ responseInfo:Dictionary<String, Any>)
    
}

class AudioStreamNet:NSObject,  URLSessionDelegate, URLSessionDataDelegate{

    
    
    var _task:URLSessionTask?
    weak var delegate:AudioStreamNetDelegate?
    func startLoadMusic(_ urlStr:String, offset:Int)  {
        
        
        if _task != nil {
            _task?.cancel()
        }
        
        
        if let musicUrl = URL.init(string: urlStr) {
            
            var request = URLRequest.init(url: musicUrl)
            request.httpMethod = "GET"
            
            if offset > 0 {
                
                request.setValue(String.init(format: "bytes=%d-", offset), forHTTPHeaderField: "Range")
            }
            
            
            let session = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
            
            _task = session.dataTask(with: request)
            
            _task?.resume()
            
        }
        
    }
    
    
    func readDataOfLength(_ length:Int, isPlay:Bool) -> Data? {
        
        
        if _audioNetData.length - _audioReadedData.length >= length {
            
            let musicData =  _audioNetData.subdata(with: NSRange.init(location: _audioReadedData.length, length: length))
            _audioReadedData.append(musicData)
            return musicData
            
        }else {
            
            // 数据不足length 阻塞
            
            waitNetData(isPlay)
        }
        
        
        return nil
    }
    
    
    var _mutex_t:pthread_mutex_t =  pthread_mutex_t.init()
    var _cond:pthread_cond_t = pthread_cond_t.init()
    func mutexInit()  {
        
        pthread_mutex_init(&_mutex_t, nil)
        pthread_cond_init(&_cond, nil)
        
    }
    
    func waitNetData(_ isPlay: Bool)  {
        
        print("waitNetData")
        if isPlay == false {
            signalEnughtData()
            
        }else {
            
            pthread_mutex_lock(&_mutex_t)
            pthread_cond_wait(&_cond, &_mutex_t)
            pthread_mutex_unlock(&_mutex_t)
        }
    }
    
    
    func signalEnughtData() {
        
        pthread_mutex_lock(&_mutex_t)
        pthread_cond_signal(&_cond)
        pthread_mutex_unlock(&_mutex_t)
    }
    
    
    func mutexDestory() {
        
        pthread_mutex_destroy(&_mutex_t)
        pthread_cond_destroy(&_cond)
        
    }
    
    
    var _audioNetData = NSMutableData()
    var _audioReadedData = NSMutableData()
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        completionHandler(.allow)
        
        _audioNetData = NSMutableData()
        _audioReadedData = NSMutableData()
        
        
        
        if let httpResponse = response as? HTTPURLResponse {
            
            self.delegate?.netHandDataWithResponse(httpResponse.allHeaderFields as! Dictionary<String, Any>)
            
        }
        
        
        
    }
    
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        _audioNetData.append(data)
        signalEnughtData()
        
    }
    
    var isFinishLoad = false
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        
        isFinishLoad = true
    }
    
}
