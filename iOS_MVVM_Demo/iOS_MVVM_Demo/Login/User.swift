
//
//  User.swift
//  RxSwift_Part1
//
//  Created by shengling on 2018/6/11.
//  Copyright © 2018年 ShengLing. All rights reserved.
//

import Foundation
import ObjectMapper

struct User: Mappable {
    
    var id: Int?
    var url: String?
    var name: String?
    var email: String?
    var repos: String?
    var bio: String?
    var blog: String?
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        url <- map["url"]
        email <- map["email"]
        repos <- map["public_repos"]
        bio <- map["bio"]
        blog <- map["blog"]
    }

}
