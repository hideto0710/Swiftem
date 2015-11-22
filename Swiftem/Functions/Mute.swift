//
//  Mute.swift
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
    public func mute(filterId: Int, docIds: [String],
        completionHandler: (response: Either<String, Int>) -> Void) -> Alamofire.Request {
            return MuteFunction(token: t).mute(filterId, docIds: docIds, completionHandler: completionHandler)
    }
}

public class MuteFunction: EMRequest {
    public func mute(filterId: Int, docIds: [String], completionHandler: (response: Either<String, Int>) -> Void) -> Alamofire.Request {
        let url = "\(self.resource)/mute/\(filterId.description)"
        Logger.debug(url)
        let params = [ "doc_ids": docIds ]
        self.headers["Authorization"] = t
        return Alamofire.request(.PUT, url, headers: self.headers, parameters: params, encoding: .JSON)
            .response { _, response, _, _ in
                if let r = response {
                    completionHandler(response: Either.Right(r.statusCode))
                } else { completionHandler(response: Either.Left("no response.")) }
        }
    }
}