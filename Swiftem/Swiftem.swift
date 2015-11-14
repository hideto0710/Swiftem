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
    let t: String
    public init(token: String) {
        t = token
    }
}

extension Swiftem {
    public func keywords(id: Int) -> KeywordBuilder {
        return KeywordBuilder(token: t, id: id)
    }
    
    public func keywords() -> KeywordBuilder {
        return KeywordBuilder(token: t, id: nil)
    }
    
    public func filters(id: Int) -> FilterBuilder {
        return FilterBuilder(token: t, id: id)
    }
    
    public func filters() -> FilterBuilder {
        return FilterBuilder(token: t, id: nil)
    }
}