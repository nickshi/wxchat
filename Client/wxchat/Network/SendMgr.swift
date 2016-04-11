//
//  SendMgr.swift
//  wxchat
//
//  Created by Junhua Shi on 4/7/16.
//  Copyright © 2016 nick. All rights reserved.
//

class SendMgr {
    
    static let mgr = SendMgr()
    
    var wxSocket : WXWebSocket
    
    init(){
        wxSocket = WXWebSocket()
    }
    
    func connect() {
        wxSocket.connect()
    }
    
    func disconnect() {
        wxSocket.disconnect()
    }
    
    
    func login(userName:String, password:String, callback:WXResponseCallBack) {
        
        let msgID = 1
        
        var resDic = [String:AnyObject]()
        resDic["msgID"] = msgID
        resDic["userName"] = userName
        resDic["password"] = password
        
        let strJson = Helper.dicToJsonString(resDic)
        
        let request = WXRequest(messageID: msgID, requestContent: strJson, handler: callback, removeHandler: true)
        
        wxSocket.sendRequest(request)
    }

}