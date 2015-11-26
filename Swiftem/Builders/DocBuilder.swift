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
        return DocBuilder(token: t, id: id, categ: categ, date: date)
    }
    
    public func docs() -> DocBuilder {
        return DocBuilder(token: t, id: nil, categ: nil, date: nil)
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
    
    init(token: String, id: Int?, categ: Swiftem.SiteCategs?, date: [String]?) {
        super.init(token: token)
        self.b.filterId = id
        self.b.siteCateg = categ
        self.b.date = date
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
        return optUrl()!
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
    public func filterId(id: Int) -> Self {
        self.b.filterId = id
        return self
    }
    
    public func siteCateg(s: Swiftem.SiteCategs) -> Self {
        self.b.siteCateg = s
        return self
    }
    
    public func date(date: [String]) -> Self {
        self.b.date = date
        return self
    }
    
    public func addDate(date: String) -> Self {
        self.b.date?.append(date)
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