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
    
}
