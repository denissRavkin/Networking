//
//  Result.swift
//  Networking
//
//  Created by Denis Ravkin on 02.07.2021.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
