//
//  TransAPI.swift
//  OrangeBank
//
//  Created by Luis Rodrigues on 24/01/2019.
//  Copyright © 2018 Luis Rodrigues. All rights reserved.
//

import Alamofire
import Foundation

public enum TransAPI: URLRequestConvertible {
    
    case list()
    
    var method: HTTPMethod {
        switch self {
        case .list():
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .list():
            return "/bins/1a30k8"
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        
        let url = try Config.apiBaseUrl.asURL()
        
        let parameters: [String: Any] = {
            switch self {
            case .list():
                return [:]
            }
        }()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch self {
        default:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
