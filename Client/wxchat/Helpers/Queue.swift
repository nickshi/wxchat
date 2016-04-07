//
//  Queue.swift
//  wxchat
//
//  Created by Junhua Shi on 4/7/16.
//  Copyright © 2016 nick. All rights reserved.
//

class _QueueItem<T> {
    let value: T!
    var next: _QueueItem?
    
    init(_ newvalue:T?) {
        self.value = newvalue
    }
}

public class Queue<T> {
    typealias Element = T
    
    var _front: _QueueItem<Element>
    var _back:_QueueItem<Element>
    
    public init() {
        _back = _QueueItem(nil)
        _front = _back
    }
    
    
    public func enqueue(value: T) {
        _back.next = _QueueItem(value)
        _back = _back.next!
    }
    
    public func dequeue() ->T? {
        if let newhead = _front.next {
            _front = newhead
        }
        else
        {
            return nil
        }
    }
}