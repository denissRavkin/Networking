//
//  User.swift
//  Networking
//
//  Created by Denis Ravkin on 22.06.2021.
//

import Foundation

protocol UserForCell {
    var name: String? { get }
}

struct User: Decodable, UserForCell {
    let id: Int?
    let name: String?
    let phone: String?
}
