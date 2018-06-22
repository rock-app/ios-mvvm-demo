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
        return .get
    }
    
    var path: String {
        return "/user"
    }
    
    var parameters: APIParams {
        return nil
    }
    
    var bodyParameters: [String : Any]? {
//        switch self {
//        case let .login(name, password):
//            return ["mobile": name, "password": password]
//        }
        return nil
    }
    
    var headers: [String : String]? {
        switch self {
        case let .login(name, password):
            guard let base64LoginString = String(format: "%@:%@", name, password)
                .data(using: .utf8)?.base64EncodedString() else { return nil }
            return ["Authorization": "Basic \(base64LoginString)"]
        }
    }
}
