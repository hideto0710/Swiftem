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

public struct SearchBuilder {
    public enum ReadStauses {
        case All
        case Read
        case Unread
        case EveryoneUnread
        
        public func toString() -> String {
            switch self {
            case .All: return "all"
            case .Read: return "read"
            case .Unread: return "unread"
            case .EveryoneUnread: return "everyone_unread"
            }
        }
    }
    
    public enum SortBy {
        case CreatedAt
        case Score
        case ClusterSize
        
        public func toString() -> String {
            switch self {
            case .CreatedAt: return "created_at"
            case .Score: return "score"
            case .ClusterSize: return "cluster_size"
            }
        }
    }
    
    public enum SortOrder {
        case Asc
        case Desc
        
        public func toString() -> String {
            switch self {
            case .Asc: return "asc"
            case .Desc: return "desc"
            }
        }
    }
}