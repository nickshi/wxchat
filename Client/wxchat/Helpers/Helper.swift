//
//  Helper.swift
//  wxchat
//
//  Created by Junhua Shi on 4/6/16.
//  Copyright © 2016 nick. All rights reserved.
//

import Foundation


class Helper {
    
    static func dicToJsonString(jsonDic:[String:AnyObject]) ->String!
    {
        
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(jsonDic, options: NSJSONWritingOptions.PrettyPrinted)
            
            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
            
            return jsonString

        } catch let error as NSError {
            print(error)
        }
        
        return nil
        
    }
    
    
}
