
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
    // 运营商
    var epId: String?
    // 姓名
    var name: String?
    // 手机号
    var mobile: String?
    // 拼音
    var pinyin: String?
    // 性别
    var gender: String?
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        epId <- map["epId"]
        name <- map["name"]
        mobile <- map["mobile"]
        pinyin <- map["pinyin"]
        gender <- map["gender"]
    }

}
