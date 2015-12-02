//
//  FilterBuilder.swift
//  Swiftem
//
//  Created by InamuraHideto on 11/14/15.
//  Copyright © 2015 InamuraHideto. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import enum Swiftx.Either

extension Swiftem {
    public func filters(id: Int) -> FilterBuilder {
        return FilterBuilder(token: t, id: id, clientId: nil, userId: nil)
    }
    
    public func filters() -> FilterBuilder {
        return FilterBuilder(token: t, id: nil, clientId: nil, userId: nil)
    }
    
    public typealias FilterType = (id: Int ,name: String, keywordId: Int)
}

public class FilterBuilder: EMRequest, EMQueryBuilder {
    public typealias BuildType = (keywordId: Int?, userId: Int?, clientId: Int?)
    public typealias ResponseType = [Swiftem.FilterType]
    
    var k = BuildType(nil, nil, nil)
    
    init(token: String, id: Int?, clientId: Int?, userId: Int?) {
        super.init(token: token)
        self.k.keywordId = id
        self.k.clientId = clientId
        self.k.userId = userId
    }
    
    private func optUrl() -> String? {
        if let kId = self.k.keywordId {
            return "\(self.resource)/filters/\(kId.description)"
        } else if let uId = self.k.userId, cId = self.k.clientId {
            return "\(self.resource)/filters/\(cId.description)/\(uId.description)"
        } else {
            return nil
        }
    }
    
    public func execute(completionHandler: (response: Either<String, ResponseType>) -> Void) -> Alamofire.Request {
        let url = optUrl()!
        Logger.debug(url)
        self.headers["Authorization"] = t
        return Alamofire.request(.GET, url, headers: self.headers).responseJSON { response in
            if let v = response.result.value {
                if let results = JSON(v)["filters"].array {
                    completionHandler(response: Either.Right(results.flatMap{self.parse($0)}))
                } else { completionHandler(response: Either.Left("filters not found.")) }
            } else { completionHandler(response: Either.Left("no response.")) }
        }
    }
    
    public func build() -> String {
        return optUrl()!
    }
}

extension FilterBuilder {
    private func parse(json: JSON) -> Swiftem.FilterType? {
        if let id = json["id"].int,
            name = json["name"].string,
            keywordId = json["keyword_id"].int {
                return (id, name, keywordId)
        } else {
            return nil
        }
    }
}

extension FilterBuilder {
    public func keywordId(id: Int) -> FilterBuilder {
        return FilterBuilder(token: self.t, id: id, clientId: self.k.clientId, userId: self.k.userId)
    }
    
    public func userId(id: Int) -> FilterBuilder {
        self.k.userId = id
        return FilterBuilder(token: self.t, id: self.k.keywordId, clientId: self.k.clientId, userId: id)
    }
    
    public func clientId(id: Int) -> FilterBuilder {
        return FilterBuilder(token: self.t, id: self.k.keywordId, clientId: id, userId: self.k.userId)
    }
}