//
//  Label.swift
//  Swiftem
//
//  Created by InamuraHideto on 11/22/15.
//  Copyright © 2015 InamuraHideto. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import enum Swiftx.Either

extension Swiftem {
    public func labels(clientId: Int,
        completionHandler: (response: Either<String, [LabelDetailType]>) -> Void) -> Alamofire.Request {
            return LabelFunction(token: t).labels(clientId, completionHandler: completionHandler)
    }
    
    public func label(labelId: Int, keywordId: Int, docIds: [String],
        completionHandler: (response: Either<String, Int>) -> Void) -> Alamofire.Request {
            return LabelFunction(token: t).label(labelId, keywordId: keywordId, docIds: docIds, completionHandler: completionHandler)
    }
}

public typealias LabelDetailType = (
    id: Int ,
    clientId: Int,
    userId: Int,
    name: String,
    style: String,
    share: Int,
    orderIndex: Int,
    createdAt: String,
    updatedAt: String
)

public class LabelFunction: EMRequest {
    
    public func labels(clientId: Int, completionHandler: (response: Either<String, [LabelDetailType]>) -> Void) -> Alamofire.Request {
        let url = "\(self.resource)/labels/\(clientId.description)"
        Logger.debug(url)
        self.headers["Authorization"] = t
        return Alamofire.request(.GET, url, headers: self.headers)
            .responseJSON { response in
                if let v = response.result.value {
                    if let labels = JSON(v)["labels"].array {
                        completionHandler(response: Either.Right(labels.flatMap{self.parse($0)}))
                    } else { completionHandler(response: Either.Left("docs not found.")) }
                } else { completionHandler(response: Either.Left("no response.")) }
        }
    }
    
    public func label(labelId: Int, keywordId: Int, docIds: [String], completionHandler: (response: Either<String, Int>) -> Void) -> Alamofire.Request {
        let url = "\(self.resource)/label/\(labelId.description)/\(keywordId.description)"
        Logger.debug(url)
        let params = [ "doc_ids": docIds ]
        self.headers["Authorization"] = t
        return Alamofire.request(.POST, url, headers: self.headers, parameters: params, encoding: .JSON)
            .response { _, response, _, _ in
                if let r = response {
                    completionHandler(response: Either.Right(r.statusCode))
                } else { completionHandler(response: Either.Left("no response.")) }
        }
    }
    
}

extension LabelFunction {
    private func parse(json: JSON) -> LabelDetailType? {
        if let id = json["id"].int,
            clientId = json["client_id"].int,
            userId = json["user_id"].int,
            name = json["name"].string,
            style = json["style"].string,
            share = json["share"].int,
            orderIndex = json["user_id"].int,
            createdAt = json["created_at"].string,
            updatedAt = json["updates_at"].string {
                return (id, clientId, userId, name, style, share, orderIndex, createdAt, updatedAt)
        } else {
            return nil
        }
    }
}