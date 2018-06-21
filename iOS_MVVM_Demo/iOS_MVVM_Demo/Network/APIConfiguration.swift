//
//  APIConfiguration.swift
//  RxSwift_Part1
//
//  Created by shengling on 2018/6/6.
//  Copyright © 2018年 ShengLing. All rights reserved.
//

import Foundation
import Alamofire

typealias APIParams = [String: Any]?

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: APIParams { get }
    var bodyParameters: [String: Any]? { get }
}

extension APIConfiguration {
    
    func asURLRequest() throws -> URLRequest {
        
        let url = URL(string: "http://bee-test.qianfan123.com:8008/dfm-web/s/")
        var urlRequest = URLRequest(url: (url?.appendingPathComponent(path))!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        //traceId
//        var traceId = UUID().uuidString
//        if let userId = SessionMgr.instance.getUser()?.id {
//            traceId = userId + "_" + String(Date().millisecondsSince1970)
//        }
//        urlRequest.setValue(traceId, forHTTPHeaderField: "trace_id")
        
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: parameters)
        urlRequest.httpBody = bodyParameters == nil ? urlRequest.httpBody : try! JSONSerialization.data(
            withJSONObject: bodyParameters!, options: [])
        
        return urlRequest
    }
    
}
extension URLRequestConvertible {
    
    func createBody(parameters: [String: String]?, boundaryConstant: String, files: (fieldName: String, fileContent: [Data]?)...) throws -> Data {
        var requestBodyData = Data()
        
        if parameters != nil {
            for (key, value) in parameters! {
                requestBodyData.append("--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                requestBodyData.append(
                    "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                requestBodyData.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        
        for file in files {
            guard file.fileContent != nil else {
                continue
            }
            let date = Date()
            for (index, contentData) in file.fileContent!.enumerated() {
                let fileName = "\(file.fieldName)\(index)\(date)"
                requestBodyData.append("--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                requestBodyData.append(
                    "Content-Disposition: form-data; name=\"\(file.fieldName)\"; filename=\"\(fileName)\"\r\n".data(
                        using: String.Encoding.utf8)!)
                requestBodyData.append("Content-Type: JPEG\r\n\r\n".data(using: String.Encoding.utf8)!)
                requestBodyData.append(contentData)
                requestBodyData.append("\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        if requestBodyData.count != 0 {
            
            requestBodyData.append("--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
        }
        return requestBodyData
    }
    
}
