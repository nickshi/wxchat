//
//  ChatTableController.swift
//  wxchat
//
//  Created by Junhua Shi on 4/6/16.
//  Copyright © 2016 nick. All rights reserved.
//


import UIKit
import Starscream


class ChatTableController: UITableViewController,WebSocketDelegate {
    
    var socket:WebSocket?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")
        
        socket = WebSocket(url: NSURL(string: "ws://localhost:4080/")!)
        socket!.delegate = self
        socket!.connect()
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