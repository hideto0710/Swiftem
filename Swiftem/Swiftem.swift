//
//  Swiftem.swift
//  Swiftem
//
//  Created by InamuraHideto on 11/14/15.
//  Copyright © 2015 InamuraHideto. All rights reserved.
//

import Foundation
import Alamofire

public struct Swiftem {
    
    let token: String
    
    public init(t: String) {
        token = t
    }
    
    public func test(resource: String) -> Alamofire.Request {
        let headers = [
            "Authorization": token,
            "Content-Type": "application/json"
        ]
        return Alamofire.request(.GET, resource, headers: headers)
    }
}