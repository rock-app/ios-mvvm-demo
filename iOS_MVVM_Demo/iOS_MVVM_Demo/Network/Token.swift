//
//  Token.swift
//  RxSwift_Part1
//
//  Created by shengling on 2018/6/14.
//  Copyright © 2018 ShengLing. All rights reserved.
//

import Foundation

class Token {
    
    static let key = "token"
    
    static let headerKey = "Authorization"
    
    static func setToken(token: HTTPCookie) {
        UserDefaults.standard.setValue(NSKeyedArchiver.archivedData(withRootObject: token), forKey: Token.key)
        UserDefaults.standard.synchronize()
    }
    
    static func getToken() -> HTTPCookie? {
        if let data = UserDefaults.standard.value(forKey: Token.key) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? HTTPCookie
        }
        return nil
    }
    
    static var current: HTTPCookie? {
        return getToken()
    }
    
    static func setHeader(header: [String: String]?) {
        UserDefaults.standard.setValue(header?[headerKey], forKeyPath: headerKey)
        UserDefaults.standard.synchronize()
    }
    
    static func getHeader() -> [String: String]? {
        if let value = UserDefaults.standard.value(forKey: headerKey) as? String {
            return [headerKey: value]
        }
        return nil
    }
    
    static var currentHeader: [String: String]? {
        return getHeader()
    }
    
}
