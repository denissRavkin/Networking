//
//  NetworkManager.swift
//  Networking
//
//  Created by Denis Ravkin on 02.07.2021.
//

import Foundation

class NetworkManager {
    var networking: Networking = NetworkService()
    
    init(networking: Networking = NetworkService()) {
        self.networking = networking
    }
    
    func getUsers(completion: @escaping (Result<[User]>)-> Void) {
        guard let url = URLService.makeUrl(host: Api.hostName.rawValue,
                                           path: Api.Path.users.rawValue,
                                           parameters: nil) else {
            completion(Result.failure(HTTPNetworkError.missingURL))
            return
        }
        
        let request = NetworkRequest.configureRequest(from: url, headers: nil, body: nil, method: .get)
        networking.makeRequest(request: request, completion: completion)
    }
    
    func getPosts(ofUserId userID: Int, completion: @escaping (Result<[Post]>)-> Void) {
        guard let url = URLService.makeUrl(host: Api.hostName.rawValue,
                                           path: Api.Path.posts.rawValue,
                                           parameters: [Api.QueryKey.userId.rawValue:"\(userID)"]) else {
            completion(Result.failure(HTTPNetworkError.missingURL))
            return
        }
        let request = NetworkRequest.configureRequest(from: url, headers: nil, body: nil, method: .get)
        networking.makeRequest(request: request, completion: completion)
    }
    
    func getPhotos(ofUserId userID: Int, completion: @escaping (Result<[Photo]>)-> Void) {
        guard let url = URLService.makeUrl(host: Api.hostName.rawValue,
                                           path: Api.Path.photos.rawValue,
                                           parameters: [Api.QueryKey.albumId.rawValue:"\(userID)"]) else {
            completion(Result.failure(HTTPNetworkError.missingURL))
            return
        }
        let request = NetworkRequest.configureRequest(from: url, headers: nil, body: nil, method: .get)
        networking.makeRequest(request: request, completion: completion)
    }
    
    func deletePost(post: Post, completion: @escaping (Result<Post>)-> Void) {
        guard let postID = post.id else { return }
        guard let url = URLService.makeUrl(host: Api.hostName.rawValue,
                                           path: Api.Path.pathToPost(postID),
                                           parameters: nil) else {
            completion(Result.failure(HTTPNetworkError.missingURL))
            return
        }
        let request = NetworkRequest.configureRequest(from: url, headers: nil, body: nil, method: .delete)
        networking.makeRequest(request: request, completion: completion)
    }
    
    func postNewPost(post: Post, completion: @escaping (Result<Post>)-> Void) {
        guard let url = URLService.makeUrl(host: Api.hostName.rawValue,
                                           path: Api.Path.posts.rawValue,
                                           parameters: nil) else {
            completion(Result.failure(HTTPNetworkError.missingURL))
            return
        }
        let jsonData: Data
        do {
            jsonData = try JSONEncoding.encodeToJSON(value: post)
        } catch {
            completion(Result.failure(error))
            return
        }
        let request = NetworkRequest.configureRequest(from: url,
                                                      headers: ["Content-type": "application/json; charset=UTF-8"],
                                                      body: jsonData,
                                                      method: HTTPMethod.post)
        networking.makeRequest(request: request, completion: completion)
    }
    
    func editPost(newPost: Post, completion: @escaping (Result<Post>)-> Void) {
        guard let oldIdPost = newPost.id else { return }
        guard let url = URLService.makeUrl(host: Api.hostName.rawValue,
                                           path: Api.Path.pathToPost(oldIdPost),
                                           parameters: nil) else {
            completion(Result.failure(HTTPNetworkError.missingURL))
            return
        }
        let jsonData: Data
        do {
            jsonData = try JSONEncoding.encodeToJSON(value: newPost)
        } catch {
            completion(Result.failure(error))
            return
        }
        let request = NetworkRequest.configureRequest(from: url,
                                                      headers: ["Content-type": "application/json; charset=UTF-8"],
                                                      body: jsonData,
                                                      method: .put)
        networking.makeRequest(request: request, completion: completion)
    }
}

