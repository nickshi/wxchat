//
//  WXWebSocket.swift
//  wxchat
//
//  Created by Junhua Shi on 4/7/16.
//  Copyright © 2016 nick. All rights reserved.
//

import Starscream


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
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("got some data: \(data.length)")
    }
    
}




