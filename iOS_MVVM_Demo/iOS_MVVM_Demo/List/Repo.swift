//
//  Repo.swift
//  iOS_MVVM_Demo
//
//  Created by shengling on 2018/6/13.
//  Copyright © 2018年 ShengLing. All rights reserved.
//

import Foundation
import ObjectMapper

struct Repo: Mappable {
    
    var id: String?
    var name: String?
    var node_id: String?
    var full_name: String?
    var isPrivate: Bool = false
    var url: String?
    var description: String?
    var stars: Int = 0
    var watchers: Int = 0
    var language: String?
    var created: Date?
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        node_id <- map["node_id"]
        full_name <- map["full_name"]
        isPrivate <- map["private"]
        url <- map["url"]
        description <- map["description"]
        stars <- map["stargazers_count"]
        watchers <- map["watchers"]
        language <- map["language"]
        created <- map["created_at"]
    }
}
