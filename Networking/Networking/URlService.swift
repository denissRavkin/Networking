//
//  URlService.swift
//  Networking
//
//  Created by Denis Ravkin on 02.07.2021.
//

import Foundation

class URLService {
    static func makeUrl(scheme: String = "https", host: String, path: String, parameters: [String: String]?) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        if let parameters = parameters {
            urlComponents.queryItems = []
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems?.append(queryItem)
            }
        }
        print(urlComponents.url)
        return urlComponents.url
    }
}
