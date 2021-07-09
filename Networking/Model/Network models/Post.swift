//
//  Post.swift
//  Networking
//
//  Created by Denis Ravkin on 02.07.2021.
//

import Foundation

protocol PostForCell {
    var title: String? { get }
    var body: String? { get }
}

struct Post: Codable, PostForCell {
    let userId: Int?
    let id: Int?
    let title: String?
    let body: String?
}
