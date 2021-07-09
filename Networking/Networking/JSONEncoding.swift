//
//  JSONEncoding.swift
//  Networking
//
//  Created by Denis Ravkin on 08.07.2021.
//

import Foundation

class JSONEncoding {
    static func encodeToJSON<T: Encodable>(value: T) throws -> Data {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(value)
            return jsonData
        } catch EncodingError.invalidValue(let value, let context){
            print("EncodingError.invalidValue - \(value), context - \(context)")
            throw HTTPNetworkError.encodingFailed
        }
    }
}
