//
//  Photo.swift
//  0519_unsplash
//
//  Created by 손대홍 on 2021/05/21.
//

import Foundation

struct Photo: Codable {
    var thumbnail: String
    var username: String
    var likesCount: Int
    var createdAt: String
}
