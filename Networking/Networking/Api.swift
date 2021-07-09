//
//  Api.swift
//  Networking
//
//  Created by Denis Ravkin on 08.07.2021.
//

import Foundation

enum Api: String {
    case hostName = "jsonplaceholder.typicode.com"
    enum Path: String {
        case users = "/users"
        case posts = "/posts"
        case photos = "/photos"
        
        static func pathToPost(_ postID: Int) -> String {
            return "/posts/\(postID)"
        }
    }
    enum QueryKey: String {
        case userId = "userId"
        case albumId = "albumId"
    }
}
