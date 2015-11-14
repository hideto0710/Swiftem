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

public typealias FilterType = (id: Int ,name: String, keywordId: Int)

public class FilterBuilder: EMRequest, EMQueryBuilder {
    public typealias BuildType = (keywordId: Int?, userId: Int?, clientId: Int?)
    public typealias ResponseType = [FilterType]
    
    var k = BuildType(nil, nil, nil)
    
    init(token: String, id: Int?) {
        super.init(token: token)
        self.k.keywordId = id
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
    private func parse(json: JSON) -> FilterType? {
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
    public func keywordId(id: Int) -> Self {
        self.k.keywordId = id
        return self
    }
    
    public func userId(id: Int) -> Self {
        self.k.userId = id
        return self
    }
    
    public func clientId(id: Int) -> Self {
        self.k.clientId = id
        return self
    }
}