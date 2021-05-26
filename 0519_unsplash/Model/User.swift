//
//  User.swift
//  0519_unsplash
//
//  Created by 손대홍 on 2021/05/26.
//

import Foundation

struct User: Codable {
    var username: String
    var name: String
    var totalLikes: Int
    var totalPhotos: Int
}
