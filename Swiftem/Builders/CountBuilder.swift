//
//  CountBuilder.swift
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
    public func counts(id: Int, categ: Swiftem.SiteCategs, from: String, to: String) -> countBuilder {
        return countBuilder(token: t, id: id, categ: categ, from: from, to: to)
    }
    
    public func counts() -> countBuilder {
        return countBuilder(token: t, id: nil, categ: nil, from: nil, to: nil)
    }
    
    public typealias CountType = (
        term: String,
        count: Int
    )
}

public class countBuilder: EMRequest, EMQueryBuilder {
    public typealias BuildType = (
        filterId: Int?,
        siteCateg: Swiftem.SiteCategs?,
        from: String?,
        to: String?,
        query: Dictionary<String, String?>
    )
    public typealias ResponseType = [Swiftem.CountType]
    
    var b = BuildType(nil, nil, nil, nil, [
        "read_status": nil,
        "labels": nil,
        "from": nil,
        "size": nil,
        "sort_by": nil,
        "sort_order": nil
        ])
    
    init(token: String, id: Int?, categ: Swiftem.SiteCategs?, from: String?, to: String?) {
        super.init(token: token)
        self.b.filterId = id
        self.b.siteCateg = categ
        self.b.from = from
        self.b.to = to
    }
    
    private func optUrl() -> String? {
        if let fId = self.b.filterId, sc = self.b.siteCateg, from = self.b.from, to = self.b.to {
            return "\(self.resource)/counts/\(fId.description)/\(sc.toString())/\(from)/\(to)"
        } else {
            return nil
        }
    }
    
    public func execute(completionHandler: (response: Either<String, ResponseType>) -> Void) -> Alamofire.Request {
        let url = optUrl()!
        var params = Dictionary<String, String>()
        for (key, val) in self.b.query {
            if let v = val {
                params[key] = v
            }
        }
        Logger.debug(url)
        self.headers["Authorization"] = t
        return Alamofire.request(.GET, url, headers: self.headers, parameters: params).responseJSON { response in
            if let v = response.result.value {
                if let results = JSON(v)["counts"].array {
                    completionHandler(response: Either.Right(results.flatMap{self.parse($0)}))
                } else { completionHandler(response: Either.Left("docs not found.")) }
            } else { completionHandler(response: Either.Left("no response.")) }
        }
    }
    
    public func build() -> String {
        return optUrl()!
    }
}

extension countBuilder {
    private func parse(json: JSON) -> Swiftem.CountType? {
        if let term = json["term"].string, count = json["count"].int {
                return (term, count)
        } else {
            return nil
        }
    }
}

extension countBuilder {
    public func filterId(id: Int) -> Self {
        self.b.filterId = id
        return self
    }
    
    public func siteCateg(s: Swiftem.SiteCategs) -> Self {
        self.b.siteCateg = s
        return self
    }
    
    public func dateFrom(from: String) -> Self {
        self.b.from = from
        return self
    }
    
    public func dateTo(to: String) -> Self {
        self.b.to = to
        return self
    }
    
    public func readStatus(s: SearchBuilder.ReadStauses) -> Self {
        self.b.query["read_status"] = s.toString()
        return self
    }
    
    public func from(from: Int) -> Self {
        self.b.query["from"] = from.description
        return self
    }
    
    public func size(size: Int) -> Self {
        self.b.query["size"] = size.description
        return self
    }
    
    public func sortBy(s: SearchBuilder.SortBy) -> Self {
        self.b.query["sort_by"] = s.toString()
        return self
    }
    
    public func sortOrder(s: SearchBuilder.SortOrder) -> Self {
        self.b.query["sort_order"] = s.toString()
        return self
    }
}