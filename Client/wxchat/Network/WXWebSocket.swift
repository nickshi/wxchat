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
            return code % 100  != 0
        }
    }
    
    init(messageID:Int, code:Int, body:String, errorMessage:String) {
        self.messageID = messageID
        self.code = code
        self.body = body
        self.errorMessage = errorMessage
    }
    
    
}

class WXRequest {
    
    var messageID: Int = 0
    var requestContent :String = ""
    var removeHandler : Bool = true
    var handler : WXResponseCallBack?
    
    init(messageID:Int, requestContent:String,handler:WXResponseCallBack, removeHandler:Bool){
        self.messageID = messageID
        self.requestContent = requestContent
        self.removeHandler = removeHandler
        self.handler = handler
    }
}


var messageUniqueID = 0
class MessageHandler {
    
    var uniqueID:String
    var messageID:Int = 0
    var handler:WXResponseCallBack?
    
    var removedWhenFinished:Bool = true
    
    init(messageID:Int, handler:WXResponseCallBack, removeWhenFinished:Bool){
        self.messageID = messageID
        self.handler = handler
        uniqueID = NSUUID().UUIDString
    }
}

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
    
    func sendRequest(requestData:WXRequest) {
        MessageDispatcher.dispatcher.registerMessageHandler(requestData.messageID, handler: requestData.handler!, removeWhenFinished: true)
        socket!.writeString(requestData.requestContent)
    }
    
}




