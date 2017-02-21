//
//  APIResponse.swift
//  Connectpal
//
//  Created by Sergei Zinin on 10/03/15.
//  Copyright (c) 2015 Connectpal. All rights reserved.
//

import Foundation

open class APIResponse {
    open var data: [String: AnyObject]
    
    public init(data: [String: AnyObject]) {
        self.data = data
    }
    
    open func getData() -> [String: AnyObject] {
        if data["data"] != nil {
            return data["data"] as! [String: AnyObject]
        } else {
            return [String: AnyObject]()
        }
    }
    
    open func getToken() -> String? {
        if data["api_token"] != nil {
            return data["api_token"] as? String
        } else {
            return nil
        }
    }
    
    open func isSuccess() -> Bool {
        return data["status"] as? String == "success"
    }
}
