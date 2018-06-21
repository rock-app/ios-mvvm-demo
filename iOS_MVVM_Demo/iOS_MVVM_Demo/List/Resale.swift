//
//  Resale.swift
//  RxSwift_Part1
//
//  Created by shengling on 2018/6/13.
//  Copyright © 2018年 ShengLing. All rights reserved.
//

import Foundation
import ObjectMapper

struct Resale: Mappable {
    
    var created: String?
    var modified: String?
    var creator: String?
    var modifier: String?
    var orgType: String?
    var orgId: String?
    var id: String?
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        created <- map["created"]
        modified <- map["modified"]
        creator <- map["creator"]
        orgType <- map["orgType"]
        orgId <- map["orgId"]
        id <- map["id"]
    }
}
