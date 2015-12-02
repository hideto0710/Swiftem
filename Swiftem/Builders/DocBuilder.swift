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
    public func docs(id: Int, categ: Swiftem.SiteCategs, date: [String]) -> DocBuilder {
        return DocBuilder(token: t, id: id, categ: categ, date: date, query: Dictionary<String, String?>())
    }
    
    public func docs() -> DocBuilder {
        return DocBuilder(token: t, id: nil, categ: nil, date: nil, query: Dictionary<String, String?>())
    }
    
    public typealias LabelType = (
        id: Int,
        name: String,
        style: String,
        share: Int,
        orderIndex: Int
    )
    
    public typealias DocType = (
        id: String,
        url: String,
        title: String,
        createdAt: String,
        snippets: [String],
        siteCateg: Swiftem.SiteCategs,
        siteName: String,
        author: String,
        authorImageUrl: String?,
        imageUrls: [String],
        labels: [LabelType],
        clusterId: String,
        clusterSize: Int
    )
}

public class DocBuilder: EMRequest, EMQueryBuilder {
    public typealias BuildType = (
        filterId: Int?,
        siteCateg: Swiftem.SiteCategs?,
        date: [String]?,
        query: Dictionary<String, String?>
    )
    public typealias ResponseType = [Swiftem.DocType]
    
    var b = BuildType(nil, nil, nil, [
        "read_status": nil,
        "labels": nil,
        "from": nil,
        "size": nil,
        "sort_by": nil,
        "sort_order": nil
    ])
    
    init(token: String, id: Int?, categ: Swiftem.SiteCategs?, date: [String]?, query: Dictionary<String, String?>) {
        super.init(token: token)
        self.b.filterId = id
        self.b.siteCateg = categ
        self.b.date = date
        self.b.query = query
    }
    
    private func optUrl() -> String? {
        if let fId = self.b.filterId, sc = self.b.siteCateg, date = self.b.date {
            let ds = date.joinWithSeparator(",")
            return "\(self.resource)/docs/\(fId.description)/\(sc.toString())/\(ds)"
        } else {
            return nil
        }
    }
    
    public func execute(completionHandler: (response: Either<String, ResponseType>) -> Void) -> Alamofire.Request {
        let url = optUrl()!
        var params = Dictionary<String, String>()
        for (key, val) in self.b.query {
            if let v = val { params[key] = v }
        }
        Logger.debug(url)
        self.headers["Authorization"] = t
        return Alamofire.request(.GET, url, headers: self.headers, parameters: params).responseJSON { response in
            if let v = response.result.value {
                if let results = JSON(v)["result"].array {
                    completionHandler(response: Either.Right(results.flatMap{self.parse($0)}))
                } else { completionHandler(response: Either.Left("docs not found.")) }
            } else { completionHandler(response: Either.Left("no response.")) }
        }
    }
    
    public func build() -> String {
        return optUrl()! + self.b.query.description
    }
}

extension DocBuilder {
    private func parse(json: JSON) -> Swiftem.DocType? {
        if let id = json["id"].string,
            url = json["url"].string,
            title = json["title"].string,
            createdAt = json["created_at"].string,
            snippets = json["snippets"].array,
            siteCateg = json["site_categ"].string,
            siteName = json["site_name"].string,
            author = json["author"].string,
            imageUrls = json["image_urls"].array,
            labels = json["labels"].array,
            clusterId = json["cluster_id"].string,
            clusterSize = json["cluster_size"].int {
                let ls: [Swiftem.LabelType] = labels.flatMap{self.parseLabels($0)}
                let authorImageUrl = json["author_image_url"].string
                let ss = snippets.flatMap({$0.string})
                let ius: [String] = imageUrls.flatMap{$0.string}
                let sc = Swiftem.siteCateg2Enum(siteCateg)
                return (id, url, title, createdAt, ss, sc, siteName, author,
                    authorImageUrl, ius, ls, clusterId, clusterSize)
        } else {
            return nil
        }
    }
    
    private func parseLabels(json: JSON) -> Swiftem.LabelType? {
        if let id = json["id"].int,
            name = json["name"].string,
            style = json["style"].string,
            share = json["share"].int,
            orderIndex = json["order_index"].int {
                return (id, name, style, share, orderIndex)
        } else {
            return nil
        }
    }
}

extension DocBuilder {
    public func filterId(id: Int) -> DocBuilder {
        let b = self.b
        return DocBuilder(token: self.t, id: id, categ: b.siteCateg, date: b.date, query: b.query)
    }
    
    public func siteCateg(s: Swiftem.SiteCategs) -> DocBuilder {
        let b = self.b
        return DocBuilder(token: self.t, id: b.filterId, categ: s, date: b.date, query: b.query)
    }
    
    public func date(date: [String]) -> DocBuilder {
        let b = self.b
        return DocBuilder(token: self.t, id: b.filterId, categ: b.siteCateg, date: date, query: b.query)
    }
    
    public func addDate(date: String) -> DocBuilder {
        var b = self.b
        b.date?.append(date)
        return DocBuilder(token: self.t, id: b.filterId, categ: b.siteCateg, date: b.date, query: b.query)
    }
    
    public func readStatus(s: SearchBuilder.ReadStauses) -> DocBuilder {
        let b = self.b
        var query = self.b.query
        query["read_status"] = s.toString()
        return DocBuilder(token: self.t, id: b.filterId, categ: b.siteCateg, date: b.date, query: query)
    }
    
    public func from(from: Int) -> DocBuilder {
        let b = self.b
        var query = self.b.query
        query["from"] = from.description
        return DocBuilder(token: self.t, id: b.filterId, categ: b.siteCateg, date: b.date, query: query)
    }
    
    public func size(size: Int) -> DocBuilder {
        let b = self.b
        var query = self.b.query
        query["size"] = size.description
        return DocBuilder(token: self.t, id: b.filterId, categ: b.siteCateg, date: b.date, query: query)
    }
    
    public func sortBy(s: SearchBuilder.SortBy) -> DocBuilder {
        let b = self.b
        var query = self.b.query
        query["sort_by"] =  s.toString()
        return DocBuilder(token: self.t, id: b.filterId, categ: b.siteCateg, date: b.date, query: query)
    }
    
    public func sortOrder(s: SearchBuilder.SortOrder) -> DocBuilder {
        let b = self.b
        var query = self.b.query
        query["sort_order"] =  s.toString()
        return DocBuilder(token: self.t, id: b.filterId, categ: b.siteCateg, date: b.date, query: query)
    }
}