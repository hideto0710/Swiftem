//
//  Swiftem.swift
//  Swiftem
//
//  Created by InamuraHideto on 11/14/15.
//  Copyright © 2015 InamuraHideto. All rights reserved.
//

import Foundation
import Alamofire

public struct Swiftem {
    let t: String
    public init(token: String) {
        t = token
    }
}

extension Swiftem {
    public enum SiteCategs {
        case TwoCH
        case All
        case BBS
        case Blog
        case Comm
        case Corp
        case EC
        case ETC
        case Job
        case Mail
        case Map
        case News
        case HP
        case Twitter
        
        func toString() -> String {
            switch self {
            case .TwoCH: return "2ch"
            case .All: return "all"
            case .BBS: return "bbs"
            case .Blog: return "blog"
            case .Comm: return "comm"
            case .Corp: return "corp"
            case .EC: return "tc"
            case .ETC: return "etc"
            case .Job: return "job"
            case .Mail: return "mail"
            case .Map: return "map"
            case .News: return "news"
            case .HP: return "hp"
            case .Twitter: return "twitter"
            }
        }
    }
    
    public static func siteCateg2Enum(siteStr: String) -> SiteCategs {
        switch siteStr {
        case "2ch": return SiteCategs.TwoCH
        case "all": return SiteCategs.All
        case "bbs": return SiteCategs.BBS
        case "blog": return SiteCategs.Blog
        case "comm": return SiteCategs.Comm
        case "corp": return SiteCategs.Corp
        case "ec": return SiteCategs.EC
        case "etc": return SiteCategs.ETC
        case "job": return SiteCategs.Job
        case "mail": return SiteCategs.Mail
        case "map": return SiteCategs.Map
        case "news": return SiteCategs.News
        case "hp": return SiteCategs.HP
        case "twitter": return SiteCategs.Twitter
        default: return SiteCategs.ETC
        }
    }
}