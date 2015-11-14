//
//  DocBuilder.swift
//  Swiftem
//
//  Created by InamuraHideto on 11/15/15.
//  Copyright © 2015 InamuraHideto. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import enum Swiftx.Either

extension Swiftem {
    public func docs(id: Int, categ: String, date: String) -> DocBuilder {
        return DocBuilder(token: t, id: id, categ: categ, date: date)
    }
    public func docs() -> DocBuilder {
        return DocBuilder(token: t, id: nil, categ: nil, date: nil)
    }
}

public typealias DocType = (id: String, title: String, detail: String, url: String, clusterId: String, pictureUrl: String?)

public class DocBuilder: EMRequest, EMQueryBuilder {
    public typealias BuildType = (filterId: Int?, siteCateg: String?, from: String?, to: String?)
    public typealias ResponseType = [DocType]
    
    var b = BuildType(nil, nil, nil, nil)
    
    init(token: String, id: Int?, categ: String?, date: String?) {
        super.init(token: token)
        self.b.filterId = id
        self.b.siteCateg = categ
        self.b.from = date
    }
    
    private func optUrl() -> String? {
        if let fId = self.b.filterId, sc = self.b.siteCateg {
            if let from = self.b.from, to = self.b.to {
                return "\(self.resource)/docs/\(fId.description)/\(sc)/\(from)/\(to)"
            } else if let date = self.b.from {
                return "\(self.resource)/docs/\(fId.description)/\(sc)/\(date)"
            } else {
                return nil
            }
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
                if let results = JSON(v)["result"].array {
                    completionHandler(response: Either.Right(results.flatMap{self.parse($0)}))
                } else { completionHandler(response: Either.Left("docs not found.")) }
            } else { completionHandler(response: Either.Left("no response.")) }
        }
    }
    
    public func build() -> String {
        return optUrl()!
    }
}

extension DocBuilder {
    private func parse(json: JSON) -> DocType? {
        if let id = json["id"].string,
            title = json["title"].string,
            detail = json["snippets"][0].string,
            url = json["url"].string,
            clusterId = json["cluster_id"].string {
                let pictureUrl = json["author_image_url"].string
                return (id, title, detail, url, clusterId, pictureUrl)
        } else {
            return nil
        }
    }
}

extension DocBuilder {
    public func filterId(id: Int) -> Self {
        self.b.filterId = id
        return self
    }
    
    public func siteCateg(categ: String) -> Self {
        self.b.siteCateg = categ
        return self
    }
    
    public func date(date: String) -> Self {
        self.b.from = date
        return self
    }
    
    public func from(from: String) -> Self {
        self.b.from = from
        return self
    }
    
    public func to(to: String) -> Self {
        self.b.to = to
        return self
    }
}