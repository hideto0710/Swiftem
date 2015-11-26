//
//  KeywordBuilder.swift
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
    public func keywords(id: Int) -> KeywordBuilder {
        return KeywordBuilder(token: t, id: id)
    }
    
    public func keywords() -> KeywordBuilder {
        return KeywordBuilder(token: t, id: nil)
    }
    
    public typealias KeywordType = (id: Int ,name: String)
}

public class KeywordBuilder: EMRequest, EMQueryBuilder {
    public typealias BuildType = (Int?)
    public typealias ResponseType = [Swiftem.KeywordType]
    
    var k = BuildType()
    
    init(token: String, id: Int?) {
        super.init(token: token)
        self.k = id
    }
    
    public func execute(completionHandler: (response: Either<String, ResponseType>) -> Void) -> Alamofire.Request {
        let url = "\(self.resource)/keywords/\(k!.description)"
        Logger.debug(url)
        self.headers["Authorization"] = t
        return Alamofire.request(.GET, url, headers: self.headers).responseJSON { response in
            if let v = response.result.value {
                if let results = JSON(v)["keywords"].array {
                    completionHandler(response: Either.Right(results.flatMap{self.parse($0)}))
                } else { completionHandler(response: Either.Left("keywords not found.")) }
            } else { completionHandler(response: Either.Left("no response.")) }
        }
    }
}

extension KeywordBuilder {
    private func parse(json: JSON) -> Swiftem.KeywordType? {
        if let id = json["id"].int, name = json["word"].string {
            return (id, name)
        } else { return nil }
    }
}

extension KeywordBuilder {
    public func id(id: Int) -> Self {
        k = id
        return self
    }
}