//
//  NetworkService.swift
//  Networking
//
//  Created by Denis Ravkin on 08.07.2021.
//

import Foundation

protocol Networking {
    func makeRequest<T: Decodable>(request: URLRequest, completion: @escaping ((Result<T>) -> Void) )
}

class NetworkService: Networking {
    private let session = URLSession(configuration: .default)
    private var task: URLSessionTask?
    
    func makeRequest<T: Decodable>(request: URLRequest, completion: @escaping ((Result<T>) -> Void) ) {
        createTask(request: request, completion: completion)
        task?.resume()
    }
    
    private func createTask<T: Decodable>(request: URLRequest, completion: @escaping ((Result<T>) -> Void)) {
        let completionHandler = { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completion(Result.failure(error))
            }
            if let response = response as? HTTPURLResponse, let unwrappedData = data {
                let result = HTTPNetworkResponse.handleNetworkResponse(for: response)
                switch result {
                case .success:
                    print("result - success")
                    do {
                        let decoded = try JSONDecoding.decodeJSON(type: T.self, from: unwrappedData)
                        completion(Result.success(decoded))
                    } catch {
                        completion(Result.failure(error))
                    }
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
        }
        switch request.httpMethod {
        case HTTPMethod.get.rawValue,
             HTTPMethod.delete.rawValue:
            task = session.dataTask(with: request, completionHandler: completionHandler)
        case HTTPMethod.post.rawValue,
             HTTPMethod.put.rawValue,
             HTTPMethod.patch.rawValue:
            task = session.uploadTask(with: request, from: request.httpBody, completionHandler: completionHandler)
        default:
            print("switch request.httpMethod - default")
            break
        }
    }
    
    func cancel() {
        task?.cancel()
    }
}
