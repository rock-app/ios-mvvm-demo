//
//  Networking.swift
//  RxSwift_Part1
//
//  Created by shengling on 2018/6/6.
//  Copyright © 2018年 ShengLing. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import ObjectMapper

enum Result<Value> {
    case success(Value)
    case failure(NetworkError)
}

enum NetworkError: Error {
    case alert(Int)
    case toast(String)
    
    var message: String {
        switch self {
        case .alert(let code):
            switch code {
            case 401:
                return "登录已过期,请重新登录!"
            case 403:
                return "禁止访问!"
            case 503:
                return "服务器升级中!"
            case 500:
                return "服务器内部错误!"
            case 404:
                return "链接错误"
            default:
                return "服务器访问失败！"
            }
        case .toast(let msg):
            return msg
        }
    }
}

struct NetResponse: Mappable {
    var success: Bool = false
    var data: Any?
    var more: Bool = false
    var message: [String] = []
    
    init() {
        
    }
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        success <- map["success"]
        data <- map["data"]
        more <- map["more"]
        message <- map["message"]
    }
}

final class Networking {
    
    static let `default` = Networking()
    
    private init() {}
    
    func request(_ router: URLRequestConvertible, _ plugins: [Plugin] = [TokenPlugin()]) -> Observable<Result<NetResponse>> {
        plugins.forEach { $0.willSendRequest(router) }
        return Observable.create { (observer) -> Disposable in
            Alamofire.request(router).responseJSON(completionHandler: { (resp: DataResponse<Any>) in
                plugins.forEach { $0.didReceiverResponse(resp) }
                switch resp.result {
                case let .failure(error):
                    print("服务器返回错误信息====\(error.localizedDescription))")
                    observer.onNext(Result<NetResponse>.failure(NetworkError.alert(resp.response?.statusCode ?? -1)))
                case let .success(value):
                    if let json = value as? [String: Any], json["success"] != nil {
                        if  let resp = Mapper<NetResponse>().map(JSON: json) {
                            if resp.success {
                                observer.onNext(Result.success(resp))
                            } else {
                                observer.onNext(Result.failure(NetworkError.toast(resp.message.first ?? "无法访问服务器")))
                            }
                        }
                    } else {
                        var netResp = NetResponse()
                        netResp.success = true
                        netResp.data = value
                        netResp.message = []
                        observer.onNext(Result.success(netResp))
                    }
                }
            })
            return Disposables.create()
        }
    }
}

extension ObservableType {
    func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return self.map { (element) -> [T] in
            if let data = element as? NetResponse {
                if let array = data.data as? [[String: Any]] {
                    let list = array.map { (item) -> T in
                        let mapper = Mapper<T>().map(JSON: item)
                        return mapper!
                    }
                    return list
                }
            }
            return []
        }
    }
    func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return self.map { (element) -> T in
            if let data = element as? NetResponse {
                if let dic = data.data as? [String: Any] {
                    let mapper = Mapper<T>().map(JSON: dic)
                    return mapper!
                }
            }
            return Mapper<T>().map(JSON: [:])!
        }
    }
    func mapPrimary<T>(type: T.Type) -> Observable<T?> {
        return self.map { (element) -> T? in
            if let data = element as? NetResponse {
                if let primary = data.data as? T {
                    return primary
                }
            }
            return nil
        }
    }
    
}

extension ObservableType {
    func unwrapper(_ errorHandler: ((NetworkError)->())? = nil) -> Observable<NetResponse?> {
        return self.map { (element) -> NetResponse? in
            if let result = element as? Result<NetResponse> {
                switch result {
                case .success(let value):
                    return value
                case .failure(let error):
                    if let handler = errorHandler { handler(error) }
                    print(error.message)
                    return nil
                }
            }
            return nil
        }
    }
}
