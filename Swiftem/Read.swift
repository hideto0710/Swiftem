//
//  Read.swift
//  Swiftem
//
//  Created by InamuraHideto on 11/16/15.
//  Copyright © 2015 InamuraHideto. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import enum Swiftx.Either

extension Swiftem {
    public func read(filterId: Int, docIds: [String],
        completionHandler: (response: Either<String, Int>) -> Void) -> Alamofire.Request {
        return ReadFunction(token: t).read(filterId, docIds: docIds, completionHandler: completionHandler)
    }
}

public class ReadFunction: EMRequest {
    public func read(filterId: Int, docIds: [String], completionHandler: (response: Either<String, Int>) -> Void) -> Alamofire.Request {
        let url = "\(self.resource)/read/\(filterId.description)"
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