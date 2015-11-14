//
//  Builder.swift
//  Swiftem
//
//  Created by InamuraHideto on 11/14/15.
//  Copyright © 2015 InamuraHideto. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import enum Swiftx.Either

protocol EMQueryBuilder {
    typealias BuildType
    typealias ResponseType
    func execute(completionHandler: (response: Either<String, ResponseType>) -> Void) -> Alamofire.Request
}

public class EMRequest {
    let t: String
    init(token: String) {
        t = token
    }
    
    let resource = "https://web-v7.emining.jp/em"
    var headers = ["Content-Type": "application/json"]
}