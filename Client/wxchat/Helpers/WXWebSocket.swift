//
//  WXWebSocket.swift
//  wxchat
//
//  Created by Junhua Shi on 4/7/16.
//  Copyright © 2016 nick. All rights reserved.
//

import Starscream
import SwiftyJSON

class WXResponse {
    var messageID:Int = 0
    var code:Int = 0
    var body:String = ""
    var errorMessage:String = ""
    
    var hasError:Bool {
        get {
            return code != 200
        }
    }
    
    init(messageID:Int, code:Int, body:String, errorMessage:String) {
        self.messageID = messageID
        self.code = code
        self.body = body
        self.errorMessage = errorMessage
    }
    
    
}


var messageUniqueID = 0
class MessageHandler {
    
    var uniqueID:Int
    var messageID:Int = 0
    var handler:WXResponseCallBack?
    
    var removedWhenFinished:Bool = true
    
    init(messageID:Int, handler:WXResponseCallBack, removeWhenFinished:Bool){
        self.messageID = messageID
        self.handler = handler
        uniqueID = ++messageUniqueID
    }
}

class MessageDispatcher{
    static let dispatcher = MessageDispatcher()
    
    var messageHandlerDic:[Int:[MessageHandler]]
    
    init()
    {
        messageHandlerDic = [Int:[MessageHandler]]()
    }
    
    
    func registerMessageHandler(messageID:Int, handler:WXResponseCallBack, removeWhenFinished:Bool){
        
        let msgHandler = MessageHandler(messageID: messageID, handler: handler, removeWhenFinished: removeWhenFinished)
        
        let handlers = messageHandlerDic[messageID]
        
        if handlers == nil {
            messageHandlerDic[messageID] = [MessageHandler]()
        }
        messageHandlerDic[messageID]?.append(msgHandler)
        
    }
    
    func unRegisterMessageHandler(handler:MessageHandler) {
        let handlers = messageHandlerDic[handler.messageID]
        
        if handlers != nil {
           let index = messageHandlerDic[handler.messageID]?.indexOf({ (mHandler) -> Bool in
                return mHandler.uniqueID == handler.uniqueID;
            })
            
            if let iIndex = index {
                messageHandlerDic[handler.messageID]?.removeAtIndex(iIndex)
            }
        }

    }
    
    func dispatchMessage(responseData:WXResponse){
        let handlers = messageHandlerDic[responseData.messageID]
        
        handlers?.forEach({ (msgHandler) in
            msgHandler.handler!(responseData)
            if msgHandler.removedWhenFinished { self.unRegisterMessageHandler(msgHandler) }
        })
    }
    

    
    

   
}


typealias WXResponseCallBack = (WXResponse) ->Void

class WXWebSocket:WebSocketDelegate {
    
    static let sharedSocket = WXWebSocket()
    
    var socket:WebSocket?;
    
    init() {
        
        socket = WebSocket(url: NSURL(string: "ws://localhost:4080/")!)
        socket!.delegate = self
    }
    
    
    func connect(){
        socket!.connect()
    }
    
    func disconnect(){
        socket!.disconnect()
    }
    
    func websocketDidConnect(socket: WebSocket) {
        print("connect")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("disconect")
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("receive message: \(text)")
        
        let json = JSON.parse(text)
        
        let messageID = json["messageID"].intValue
        let code = json["code"].intValue
        let body = json["body"].stringValue
        let errorMessage = json["errorMessage"].stringValue
        
        let response = WXResponse(messageID:messageID, code: code, body: body, errorMessage: errorMessage)
        
        MessageDispatcher.dispatcher.dispatchMessage(response)
        
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("got some data: \(data.length)")
        
        
    }
    
    
    func login(userName:String, password:String, callback:WXResponseCallBack) {
        
        var resDic = [String:AnyObject]()
        resDic["msgID"] = 1
        resDic["userName"] = userName
        resDic["password"] = password
        
        let strJson = Helper.dicToJsonString(resDic)
        
        MessageDispatcher.dispatcher.registerMessageHandler(1, handler: callback, removeWhenFinished: true)
        socket!.writeString(strJson)
    }
    
}




