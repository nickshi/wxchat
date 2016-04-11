//
//  MessageDispatcher.swift
//  wxchat
//
//  Created by nick.shi on 4/10/16.
//  Copyright © 2016 nick. All rights reserved.
//

typealias WXResponseCallBack = (WXResponse) ->Void

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

