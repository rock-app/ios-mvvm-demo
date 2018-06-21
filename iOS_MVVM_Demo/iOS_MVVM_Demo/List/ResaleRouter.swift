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

enum ResaleRouter: APIConfiguration {
    case resales(pagingFilter: CarsalePageModel)
}

extension ResaleRouter {
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        var url = ""
        switch self {
        case .resales:
            url = "app/888888/carsales/resalebill/resalebills"
            return url
        }
    }
    
    var parameters: APIParams {
        switch self {
        case let .resales(pagingFilter):
            return pagingFilter.toJSON()
        }
//        return nil
    }
    
    var bodyParameters: [String : Any]? {
        return ["fetchLine": true]
    }
}
