//
//  ResaleRouter.swift
//  RxSwift_Part1
//
//  Created by shengling on 2018/6/13.
//  Copyright © 2018年 ShengLing. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

struct CarsalePageModel: Mappable {
    var page: Int = 0
    var pageSize: Int = 10
    var sortKey: String = ""
    var desc: String = "true"
    
    init() {
    }
    
    init(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        page <- map["page"]
        pageSize <- map["pageSize"]
        sortKey <- map["sortKey"]
        desc <- map["desc"]
    }
}

enum RepoRouter: APIConfiguration {
    case repos
}

extension RepoRouter {
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        var url = ""
        switch self {
        case .repos:
            url = "/user/repos"
            return url
        }
    }
    
    var parameters: APIParams {
        return nil
    }
    
    var bodyParameters: [String : Any]? {
        return nil
    }
    
    var headers: [String : String]? {
        return Token.currentHeader
    }
}
