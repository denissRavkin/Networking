//
//  HTTPNetworkRequest.swift
//  Networking
//
//  Created by Denis Ravkin on 02.07.2021.
//

import Foundation

class NetworkRequest {
    static func configureRequest(from url: URL, headers: [String: String?]?, body: Data?, method: HTTPMethod) -> URLRequest {
        var request = URLRequest(url: url, timeoutInterval: 10)
        if let headers = headers {
            setHeaders(for: &request, with: headers)
        }
        request.httpBody = body
        request.httpMethod = method.rawValue
        
        return request
    }
    
    private static func setHeaders(for urlRequest: inout URLRequest, with headers: [String: String?]) {
        for (key, value) in headers{
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
    }
}
