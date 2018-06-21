//
//  AuthRouter.swift
//  RxSwift_Part1
//
//  Created by shengling on 2018/6/11.
//  Copyright © 2018年 ShengLing. All rights reserved.
//

import Foundation
import Alamofire

enum AuthRouter: APIConfiguration {
    case login(name: String, password: String)
}

extension AuthRouter {
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "app/auth/login"
    }
    
    var parameters: APIParams {
        return nil
    }
    
    var bodyParameters: [String : Any]? {
        switch self {
        case let .login(name, password):
            return ["mobile": name, "password": password]
        }
    }
}
